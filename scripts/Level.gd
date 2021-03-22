extends Spatial

onready var gui := $GUI
var score := 0
var streak := 0

var body
var player

var spawn_interval := 0.5
var time := 0.0
onready var spawn_points := get_tree().get_nodes_in_group("SpawnPoint")

var red_puzzle := preload("res://scenes/Red_Puzzle.tscn")
var blue_puzzle := preload("res://scenes/Blue_Puzzle.tscn")
var yellow_puzzle := preload("res://scenes/Yellow_Puzzle.tscn")
var puzzles := [red_puzzle,blue_puzzle,yellow_puzzle]

var oil_barrel := preload("res://scenes/oil_barrel.tscn")
var rocket := preload("res://scenes/rocket.tscn")

func _process(delta):
	time += delta
	if time > spawn_interval:
		time -= spawn_interval
		if(body != null):
			randomize()
			var random = rand_range(0.0, 1.0)
			if(random < 0.9):
				_spawn_puzzle()
			else:
				_spawn_item()
	

func _ready() -> void:
	body = get_node("player/helper_z/helper_x/bodyhelper/body")
	body.connect("puzzle_collected", self, "_on_collect")
	player = get_node("player")
	player.connect("speed_up", self, "_on_speed_up")

func _on_collect(changed: bool) -> void:
	if changed:
		if streak >0:
			score += pow(2,streak-1)
			gui.set_score(score) 
		streak = 0
	else:
		streak +=1
		if streak >= 8:
			score += pow(2,streak-1)
			gui.set_score(score)
			streak = 0
			body.set_default_color()
	gui.set_streak(streak)

func _spawn_puzzle() -> void:
	randomize()
	var random = floor(rand_range(0.0, spawn_points.size()))
	randomize()
	var random_piece = floor(rand_range(0.0, puzzles.size()))
	var instance = puzzles[random_piece].instance()
	instance.set_transform(spawn_points[random].global_transform)
	add_child(instance)

func _spawn_item() -> void:
	randomize()
	var random = floor(rand_range(0.0, spawn_points.size()))
	randomize()
	var coin_flip = rand_range(0.0, 1.0)
	var instance
	if coin_flip < 0.5:
		instance = oil_barrel.instance()
	else:
		instance = rocket.instance()
	instance.set_transform(spawn_points[random].global_transform)
	add_child(instance)

func _on_body_tree_exited():
	gui.show_gameOver(score)

func _on_speed_up() -> void:
	gui.speedup()
