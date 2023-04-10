extends ParallaxBackground


@onready var player = get_parent().get_node("Player")
@onready var task_manager = get_parent().get_node("TaskManager")

@onready var dance_button = preload("res://DanceButton.tscn")

const hits_to_win : int = 8

var buttons : Array = []
var hits : int = 0


func _ready():
	# Place in the middle of the screen
	offset.x = 1920.0 / 2.0
	offset.y = 1080.0 / 2.0
	
	# Create the buttons
	for i in range(0, hits_to_win):
		var new_button = dance_button.instantiate()
		new_button.offset.x = offset.x - (hits_to_win / 2.0 - i) * 125
		new_button.offset.y = offset.y
		buttons.append(new_button)
		add_child(new_button)


func _process(_delta):		
	# Pressing the buttons
	if Input.is_action_just_pressed("left"):
		buttons[hits].try(0)
	if Input.is_action_just_pressed("right"):
		buttons[hits].try(1)
	if Input.is_action_just_pressed("down"):
		buttons[hits].try(2)
	if Input.is_action_just_pressed("up"):
		buttons[hits].try(3)
	
	# Exit out of the minigame
	if Input.is_action_just_pressed("interact"):
		player.init_move()
		get_parent().toggle_black()
		queue_free()


func increment():
	hits += 1
	if hits >= hits_to_win:
		player.init_move()
		get_parent().toggle_black()
		task_manager.pass_task(6) # Task.dance
		queue_free()


func decrement():
	if hits > 0:
		hits -= 1
		buttons[hits].get_node("Sprite").modulate.a = 1
