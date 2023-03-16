extends Area2D


func _on_body_entered(body):
	body.ladder = self


func _on_body_exited(body):
	body.ladder = null
	body.init_move()
