extends Spatial

onready var helper_x := $helper_z/helper_x
onready var helper_z := $helper_z
onready var body := $helper_z/helper_x/bodyhelper

signal speed_up()

var speed := 0.3
var steer := 1.3
#var y_compensation := 1
#var z_compensation := 1
var speed_up_interval := 25.0
var time := 0.0
var speed_increase := 0.05
const temp_speedup := 0.3
var tmp_speed := 0.0

func _ready():
	$helper_z/helper_x/bodyhelper/body.connect("rocket", self, "_set_tmp_speed")

func _process(delta) -> void:
	var steer_tmp = helper_x.transform.rotated(helper_x.transform.basis.y.normalized(), Input.get_action_strength("move_right")*(-steer*delta) -Input.get_action_strength("move_left")*(-steer*delta))
	helper_x.set_transform(steer_tmp)
	tmp_speed = max(tmp_speed - (delta*0.1),0.0)
	var tmp = helper_x.transform.rotated(helper_x.transform.basis.x.normalized(), (speed + tmp_speed) * delta)
	helper_x.set_transform(tmp)
	time += delta
	if(time > speed_up_interval):
		time -= speed_up_interval
		speed += speed_increase
		emit_signal("speed_up")

func _set_tmp_speed():
	tmp_speed = temp_speedup
