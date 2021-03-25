extends Area

export var color_name: String
export var color_material: Material

onready var tween = $Tween
onready var Mat = $Puzzle1_LP2/Body2003.get_surface_material(0)

var time = 0.0

func _ready():
	tween.interpolate_property($Puzzle1_LP, "rotation_degrees", Vector3(0,0,0),Vector3(0,360,0),4.0,Tween.TRANS_LINEAR)
	tween.interpolate_property($Puzzle1_LP2, "rotation_degrees", Vector3(0,0,0),Vector3(0,360,0),4.0,Tween.TRANS_LINEAR)
	tween.start()

func _on_Puzzle_body_entered(body):
	if(body.is_in_group("Player")):
		body.on_puzzle_collect(color_name, color_material)
		self.queue_free()


func _on_Timer_timeout():
	self.queue_free()

func _prepare_fade_out():
	time = 0.0

func _physics_process(delta):
	Mat.set_shader_param("cur_time", time)
	time += delta
