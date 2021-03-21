extends Area

func _on_tree_body_entered(body: Node) -> void:
	if(body.is_in_group("Player")):
		body.queue_free()
