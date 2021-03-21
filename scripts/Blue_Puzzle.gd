extends Area

export var color_name: String
export var color_material: Material

onready var tween = $Tween

func _ready():
	tween.interpolate_property($Puzzle1_LP, "rotation_degrees", Vector3(0,0,0),Vector3(0,360,0),4.0,Tween.TRANS_LINEAR)
	tween.start()

func _on_Puzzle_body_entered(body):
	if(body.is_in_group("Player")):
		body.on_puzzle_collect(color_name, color_material)
		self.queue_free()


func _on_Timer_timeout():
	self.queue_free()
