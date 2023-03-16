extends Control


# Fade and move
func _process(_delta):
	position.y -= 1
	modulate.a -= .0075
	if modulate.a <= 0:
		queue_free()


func set_text(new_text):
	$Label.text = new_text
