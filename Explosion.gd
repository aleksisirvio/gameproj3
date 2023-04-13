extends Sprite2D

var timer : float = 0

func _process(delta):
	timer -= 60 * delta
	if timer <= 0:
		modulate.a -= .05 * delta * 60
		if modulate.a <= 0:
			queue_free()
