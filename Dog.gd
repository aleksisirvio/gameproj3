extends CharacterBody2D


const spd 			: float 	= 75
const max_spd		: float	= 1000
const jump_spd 		: float 	= 1000
const grav 			: float = 1500

var max_move_timer	: float	= 180
var move_timer		: float	= 1
var hmove			: int	= 0
var move			: bool	= true

var max_task_cd		: float = 300
var task_cd			: float = 1

@onready var interactable = $Interactable
@onready var sprite = $Sprite

@onready var ui = get_parent().get_node("UI")
@onready var task_manager = get_parent().get_node("TaskManager")
@onready var player = get_parent().get_node("Player")

@onready var dog_task = preload("res://DogTask.tscn")
@onready var check = preload("res://Check.tscn")
@onready var floating_text = preload("res://FloatingText.tscn")
@onready var petting_game = preload("res://BrushingGame.tscn")
@onready var brushing_game = preload("res://PettingGame.tscn")

var task_inst = null
var wants : Array = [] # What does the dog want, e.g., "brush", "wash", "pet"...
var wants_pos : Array = []

var title : String = "Dog"

var rot_dir : float = 1
var rot_spd : float = 0
var rot_acc : float = .2
const max_rot_spd : float = 1
const max_rot : float = 5


func _ready():
	pass

	
func _process(delta):
	# Occasionally change movement direction
	move_timer -= delta * 60
	if move_timer <= 0 and move:
		move_timer = max_move_timer
		var rand = randi() % 9
		if rand < 3:
			hmove = 0
		elif rand < 6:
			hmove = -1
		else:
			hmove = 1
	
	if position.x < 700:
		hmove = 1
	if position.x > 1250:
		hmove = -1
	
	velocity.x = hmove * spd
	
	# Face forwards
	if hmove == 1:
		sprite.flip_h = true
	if hmove == -1:
		sprite.flip_h = false
		
	# Rotate for simple animation
	if abs(rot_spd) < max_rot_spd or sign(rot_spd) != rot_dir:
		rot_spd += rot_dir * rot_acc * delta * 60
	sprite.rotation_degrees += rot_spd * delta * 60
	if sprite.rotation_degrees >= max_rot:
		rot_dir = -1
	if sprite.rotation_degrees <= -max_rot:
		rot_dir = 1
			


func has_want(which):
	return wants.has(which)


func jump():
	velocity.y = -jump_spd


func interact(interacter):
	var success = false
	for i in range(0, wants.size()):
		var want = wants[i]
		match want:
			"Brush":
				if interacter.tool == want:
					player.init_pause()
					get_parent().toggle_black()
					var brushing_game_inst = brushing_game.instantiate()
					brushing_game_inst.task_index = i
					get_parent().add_child(brushing_game_inst)
			"Treat":
				if interacter.tool == want:
					interacter.set_tool("")
					ui.set_tool("-")
					var text_inst = floating_text.instantiate()
					text_inst.set_text("- " + want)
					text_inst.position.x = interacter.position.x
					text_inst.position.y = interacter.position.y - 125
					get_parent().add_child(text_inst)
					success = true
			"Pet":
				if interacter.tool == "":
					player.init_pause()
					get_parent().toggle_black()
					var petting_game_inst = petting_game.instantiate()
					petting_game_inst.task_index = i
					get_parent().add_child(petting_game_inst)
		if success:
			pass_task_at(i)
			"""
			task_inst.queue_free()
			task_inst = null
			"""
			task_cd = max_task_cd
			return true
	return false
			
			
func pass_task_at(index):
	task_manager.pass_task_at(wants_pos[index])
	wants.remove_at(index)
	wants_pos.remove_at(index)


func del_want(pos):
	for i in range(0, wants_pos.size() - 1):
		if wants_pos[i] == pos:
			wants.remove_at(i)
			wants_pos.remove_at(i)


func _physics_process(delta):
	velocity.y = clamp(velocity.y + grav * delta, -max_spd, max_spd)
	move_and_slide()


func _on_mask_body_entered(body):
	interactable.entered(body)
	# Stop the dog from moving while colliding with the player
	hmove = 0
	move = false


func _on_mask_body_exited(body):
	interactable.exited(body)
	# Allow dog to move once more
	move = true
	move_timer = 1
