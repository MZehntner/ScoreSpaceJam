extends Control

onready var score_label := $Score
onready var streak_label := $TextureRect/Streak
onready var streak_frame := $TextureRect/Sprite
onready var gameOver := $GameOver
onready var final_score := 0

onready var submit := $GameOver/Control/Button
onready var retry := $GameOver/Button
onready var quit := $GameOver/Button2
onready var nickname := $GameOver/Control/LineEdit
onready var notify := $GameOver/Control/notify
onready var http := $GameOver/Control/HTTPRequest

onready var speed_anim := $AnimationPlayer

func set_score(num: int):
	score_label.text = "Score: %s" % num

func set_streak(num: int):
	streak_label.text = "%s" % num

func set_frame(frame: int):
	streak_frame.frame = frame

func show_gameOver(score: int):
	final_score = score
	$GameOver/Label2.text = "Your score was:\n %s" % final_score
	gameOver.visible = true

func speedup():
	speed_anim.play("speed")

func _on_Button_pressed():
	get_tree().change_scene("res://scenes/Level.tscn")


func _on_submit_pressed():
	if nickname.text.empty():
		notify.text = "Nickname is empty!"
		return
	submit.disabled = true
	retry.disabled = true
	quit.disabled = true
	var body := {
		"nickname": {"stringValue": nickname.text },
		"value": {"integerValue": final_score },
	}
	Firebase.save_document("highscores", body, http)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	retry.disabled = false
	quit.disabled = false
	if response_code != 200:
		submit.disabled = false
		notify.text = "Error! Maybe retry."
	else:
		notify.add_color_override("font_color", Color.green)
		notify.text = "Success!"


func _on_Quit_pressed():
	get_tree().change_scene("res://scenes/TitleScreen.tscn")
