extends Control

onready var http := $HTTPRequest
var deleting_entries := false
export var highscore_count : int = 10
export var score_row : PackedScene


func _on_start_pressed():
	get_tree().change_scene("res://scenes/Level.tscn")


func _on_Back_pressed():
	$Leaderboard.visible = false
	$main.visible = true


func _on_quit_pressed():
	get_tree().quit()


func _on_leaderboard_pressed():
	$Leaderboard.visible = true
	$main.visible = false
	get_highscores()

func get_highscores() -> void:
	Firebase.get_document_or_collection("highscores", http)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if deleting_entries:
		return
	var request_result := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	if "documents" in request_result.keys():
		var scores := get_formated_scores(request_result.documents)
		scores.sort_custom(self, "sort_scores")
		if scores.size() > highscore_count:
			var index := scores.size() - 1
			deleting_entries = true
			while index != highscore_count - 1:
				Firebase.delete_document("highscores/%s" % scores[index].id, http)
				yield(http, "request_completed")
				index -= 1
			deleting_entries = false
			get_highscores()
		else:
			delete_current_rows()
			add_new_rows(scores)
	elif not request_result.empty():
		get_highscores()

func get_formated_scores(documents: Array) -> Array:
	var scores := []
	for document in documents:
		var split := document.name.split("/") as PoolStringArray
		scores.append({
			"nickname": document.fields.nickname.stringValue,
			"value": int(document.fields.value.integerValue),
			"id": split[split.size() - 1]
		})
	return scores

func delete_current_rows() -> void:
	for child in $Leaderboard/VBoxContainer.get_children():
		if child is ScoreRow:
			child.queue_free()

func sort_scores(a, b) -> bool:
	if a.value < b.value:
		return false
	return true

func add_new_rows(scores: Array) -> void:
	for score in scores:
		var new_score_row := score_row.instance() as ScoreRow
		$Leaderboard/VBoxContainer.add_child(new_score_row)
		new_score_row.nickname.text = score.nickname
		new_score_row.score.text = str(score.value)
