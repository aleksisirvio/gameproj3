extends Control


# Fade and move
func _process(delta):
	position.y -= delta * 60
	modulate.a -= .0075 * delta * 60
	if modulate.a <= 0:
		queue_free()


func set_text(new_text):
	$Label.text = new_text
