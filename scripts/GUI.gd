extends Control

onready var score_label := $Score
onready var streak_label := $Streak
onready var gameOver := $GameOver
onready var final_score := 0

func set_score(num: int):
	score_label.text = "Score: %s" % num

func set_streak(num: int):
	streak_label.text = "Streak: %s" % num

func show_gameOver(score: int):
	final_score = score
	$GameOver/Label2.text = "Your score was:\n %s" % final_score
	gameOver.visible = true
