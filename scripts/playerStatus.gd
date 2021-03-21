extends KinematicBody

onready var mesh := $Car/Cube2
var color := "WHITE"

export var default_color: Material

signal puzzle_collected(changed)

func on_puzzle_collect(p_color: String, material: Material) -> void:
	if(p_color != color):
		color = p_color
		_set_material(material)
		emit_signal("puzzle_collected", true)
	else:
		emit_signal("puzzle_collected", false)

func _set_material(material: Material) -> void:
	mesh.set_surface_material(0, material)

func set_default_color():
	color = "WHITE"
	mesh.set_surface_material(0,default_color)
