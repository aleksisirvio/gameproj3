extends Node


@onready var label = $Label
@onready var black_transparent = $BlackTransparent
@onready var black_full = $BlackFull

var cd : float = 180


func _process(delta):
	if label.modulate.a < 1:
		label.modulate.a += .1 * delta * 60
		black_transparent.modulate.a += .05 * delta * 60
	
	cd -= delta * 60
	if cd <= 0:
		black_full.modulate.a += .01 * delta * 60
		if black_full.modulate.a >= 1:
			get_parent().queue_free()
			get_tree().reload_current_scene()


func set_text(txt):
	label.text = txt
