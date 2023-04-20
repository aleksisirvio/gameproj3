extends Sprite2D


func _process(delta):
	modulate.a -= .025 * delta * 60
	if modulate.a <= 0:
		queue_free()
	scale.x += .05 * delta * 60
	scale.y += .05 * delta * 60
