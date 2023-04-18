extends Node


@onready var room = preload("res://Room.tscn")

@onready var play_button = $PlayButton
@onready var tutorial_button = $TutorialButton
@onready var exit_button = $ExitButton
@onready var scores_label = $Scores

@onready var buttons : Array = [play_button, tutorial_button, exit_button]

var pos : int = 0


func _ready():
	play_button.modulate.a = .5
	tutorial_button.modulate.a = .5
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
				var rm = room.instantiate()
				get_parent().add_child(rm)
				rm.tutorialize()
				queue_free()
			2:
				get_parent().save_scores()
				get_tree().quit()


func set_scores():
	scores_label.text = ""
	for i in range(0, get_parent().scores.size()):
		var score = get_parent().scores[i]
		scores_label.text += str(i+1) + ": " + str(score) + "€\n"
