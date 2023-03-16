extends Node2D


@onready var room = preload("res://Room.tscn")


func _ready():
	randomize()
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	add_child(room.instantiate())


func _process(_delta):
	# Fullscreen toggling with 'F'
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(Vector2(DisplayServer.screen_get_size() / 2))
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	# Exitting the game
	if Input.is_action_just_pressed("menu"):
		get_tree().quit()
