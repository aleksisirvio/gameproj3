extends Node


@onready var room = preload("res://Room.tscn")

@onready var play_button = $PlayButton
@onready var options_button = $OptionsButton
@onready var exit_button = $ExitButton

@onready var buttons : Array = [play_button, options_button, exit_button]

var pos : int = 0


func _ready():
	play_button.modulate.a = .5
	options_button.modulate.a = .5
	exit_button.modulate.a = .5


func _process(_delta):
	var vmove = 0
	if Input.is_action_just_pressed("down"):
		vmove = 1
	if Input.is_action_just_pressed("up"):
		vmove -= 1
	
	pos += vmove
	if pos < 0:
		pos = 2
	if pos > buttons.size() - 1:
		pos = 0
	
	for button in buttons:
		button.modulate.a = .5
	buttons[pos].modulate.a = 1
	
	if Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("interact"):
		match pos:
			0:
				get_parent().add_child(room.instantiate())
				queue_free()
			1:
				pass
			2:
				get_tree().quit()
