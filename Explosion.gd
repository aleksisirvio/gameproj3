extends Sprite2D


func _process(delta):
	modulate.a -= .05 * delta * 60
	if modulate.a <= 0:
		queue_free()
