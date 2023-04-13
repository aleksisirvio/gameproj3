extends ParallaxBackground


@onready var player = get_parent().get_node("Player")
@onready var dog = get_parent().get_node("Dog")

@onready var hit_color = $HitColor
@onready var hits_label = $HitsLabel

const hits_to_win : int = 20

var hits : int = 0

var task_index : int = -1 # Set this when creating


# Place in the middle of the screen
func _ready():
	offset.x = 1920.0 / 2.0
	offset.y = 1080.0 / 2.0
	
	hit_color.modulate.a = 0


func _process(delta):		
	if hit_color.modulate.a > 0:
		hit_color.modulate.a -= .2 * delta * 60
	
	# Pressing the buttons
	if Input.is_action_just_pressed("interact"):
		hits += 1
		hits_label.text = str(hits) + "/" + str(hits_to_win)
		hit_color.modulate.a = 1
		get_parent().play_success()
	
	if hits >= hits_to_win:
		dog.pass_task_at(task_index)
		exit()
	
	# Exit out of the minigame
	"""
	if Input.is_action_just_pressed("interact"):
		player.init_move()
		queue_free()
	"""


func exit():
	player.init_move()
	get_parent().toggle_black()
	queue_free()
