extends Sprite2D


# Fade and destroy
func _process(_delta):
	modulate.a -= .05
	if modulate.a <= 0:
		queue_free()
