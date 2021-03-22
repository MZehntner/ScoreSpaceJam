extends Area

var explo := preload("res://scenes/explosion.tscn")

func _on_tree_body_entered(body: Node) -> void:
	if(body.is_in_group("Player")):
		var instance = explo.instance()
		instance.set_transform(body.global_transform)
		get_tree().get_root().add_child(instance)
		body.queue_free()
