extends Area2D


# Make the dog jump upon collision
func _on_body_entered(body):
	if body.hmove == -1:
		body.jump()
