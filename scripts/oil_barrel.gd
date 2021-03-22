extends Area

onready var tween = $Tween

func _ready():
	tween.interpolate_property($Oil_Barrel, "rotation_degrees", Vector3(0,0,0),Vector3(0,360,0),4.0,Tween.TRANS_LINEAR)
	tween.start()

func _on_oil_body_entered(body):
	if(body.is_in_group("Player")):
		body.on_oil_barrel()


func _on_Timer_timeout():
	self.queue_free()
