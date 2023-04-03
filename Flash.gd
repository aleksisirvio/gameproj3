extends Sprite2D


# Fade and destroy
func _process(delta):
	modulate.a -= .05 * delta * 60
	if modulate.a <= 0:
		queue_free()
