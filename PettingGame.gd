extends ParallaxBackground


@onready var player = get_parent().get_node("Player")
@onready var dog = get_parent().get_node("Dog")

@onready var hit_color = $HitColor
@onready var miss_color = $MissColor
@onready var pointer = $Pointer
@onready var left_threshold = $LeftThreshold
@onready var right_threshold = $RightThreshold
@onready var hits_label = $HitsLabel

const spd : float = 10.0
const size : float = 200.0
const hits_to_win : int = 8

var pos : float = 0
var threshold : float = 100.0
var dir : int = 1
var pressed : bool = false
var hits : int = 0

var task_index : int = -1 # Set this when creating


# Place in the middle of the screen
func _ready():
	offset.x = 1920.0 / 2.0
	offset.y = 1080.0 / 2.0
	
	left_threshold.offset.x = -size + threshold
	right_threshold.offset.x = size - threshold
	
	hit_color.modulate.a = 0
	miss_color.modulate.a = 0


func _process(delta):
	# Move the pointer
	pos += spd * dir * delta * 60
	pointer.offset.x = pos
	if pos <= -size or pos >= size:
		dir = -dir
		pos += dir * 10
	
	if pos > -size + threshold and pos < size - threshold:
		pressed = false
		
	if hit_color.modulate.a > 0:
		hit_color.modulate.a -= .1 * delta * 60
	if miss_color.modulate.a > 0:
		miss_color.modulate.a -= .1 * delta * 60
	
	# Pressing the buttons
	var hit = 0
	if Input.is_action_just_pressed("left"):
		if pressed or pos > -size + threshold:
			if hits > 0:
				hit = -1
		else:
			hit = 1
			pressed = true
	if Input.is_action_just_pressed("right"):
		if pressed or pos < size - threshold:
			if hits > 0:
				hit = -1
		else:
			hit = 1
			pressed = true
	hits_label.text = str(hits) + "/" + str(hits_to_win)
	
	hits += hit
	if hit == 1:
		hit_color.modulate.a = 1
	elif hit == -1:
		miss_color.modulate.a = 1
	
	if hits >= hits_to_win:
		dog.pass_task_at(task_index)
		player.init_move()
		get_parent().toggle_black()
		queue_free()
	
	# Exit out of the minigame
	if Input.is_action_just_pressed("interact"):
		player.init_move()
		get_parent().toggle_black()
		queue_free()
