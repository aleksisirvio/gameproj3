extends ParallaxBackground


@onready var player = get_parent().get_node("Player")
@onready var task_manager = get_parent().get_node("TaskManager")

@onready var cursor = $Cursor
@onready var note = $Note
@onready var progress_label = $ProgressLabel

const bar_size : float = 600
const cursor_size : float = 150
const note_size : float = 60

const progress_spd : float = .25
var progress : float = 0

var spd : float = 0
var acc : float = .2
var grav : float = .2

const top : float = bar_size / 2 - cursor_size / 2
const bottom : float = -(bar_size / 2) + cursor_size / 2

const note_top : float = bar_size / 2 - note_size / 2
const note_bottom : float = -(bar_size / 2) + note_size / 2

var note_move_cd : float = 0
var note_target : float = 0
var note_acc : float = .1
var note_move : float = 0
var note_spd : float = 0
var note_max_spd : float = 4


func _ready():
	# Place in the middle of the screen
	offset.x = 1920.0 / 2.0
	offset.y = 1080.0 / 2.0
	
	# Place cursor at the bottom
	cursor.position.y = top


func _process(delta):		
	# Moving the cursor
	if Input.is_action_pressed("up"):
		spd -= acc * delta * 60
	else:
		spd += grav * delta * 60
	
	if cursor.position.y + spd > top:
		cursor.position.y = top
		spd = 0
	if cursor.position.y + spd < bottom:
		cursor.position.y = bottom
		spd = 0
	
	cursor.position.y += spd * delta * 60
	
	# Moving the note
	note_move_cd -= delta * 60
	if note_move_cd <= 0:
		note_move_cd = randi_range(180, 300)
		note_target = randf_range(-bar_size / 2 + 50, bar_size / 2 - 50)
	note_move = sign(note_target - note.position.y)
	if abs(note_spd) < note_max_spd or sign(note_spd) != note_move:
		note_spd += note_move * note_acc * delta * 60
	
	if note.position.y + note_spd > note_top:
		note.position.y = note_top
		note_spd = 0
	if note.position.y + note_spd < note_bottom:
		note.position.y = note_bottom
		note_spd = 0
	
	note.position.y += note_spd * delta * 60
	
	# Calculate overlap with note
	if note.position.y < cursor.position.y + cursor_size / 2 and note.position.y > cursor.position.y - cursor_size / 2:
		progress += progress_spd * delta * 60
		progress_label.text = str(round(progress)) + "/100"
		if progress >= 100:
			task_manager.pass_task(7) # Task.sing
			exit()
	
	# Exit out of the minigame
	if Input.is_action_just_pressed("interact"):
		exit()


func exit():
	player.init_move()
	get_parent().toggle_black()
	queue_free()
