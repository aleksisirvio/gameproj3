extends CharacterBody2D


const spd 			: int 	= 75
const max_spd		: int	= 1000
const jump_spd 		: int 	= 1000
const grav 			: float = 1500

var max_move_timer	: int	= 180
var move_timer		: int	= 1
var hmove			: int	= 0

var max_task_cd		: int = 300
var task_cd			: int = 1

@onready var interactable = $Interactable

@onready var ui = get_parent().get_node("UI")
@onready var task_manager = get_parent().get_node("TaskManager")

@onready var dog_task = preload("res://DogTask.tscn")
@onready var check = preload("res://Check.tscn")
@onready var floating_text = preload("res://FloatingText.tscn")

var task_inst = null
var wants : Array = [] # What does the dog want, e.g., "brush", "wash", "pet"...
var wants_pos : Array = []


func _ready():
	pass

	
func _process(delta):
	# Occasionally change movement direction
	move_timer -= delta
	if move_timer == 0:
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
	
	"""
	if task_cd > 0:
		task_cd -= 1 * delta
		if !task_cd:
			# Create new task
			task_inst = dog_task.instantiate()
			add_child(task_inst)
			task_inst.position.y -= 80
			want = "Treat"
	"""
			


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
					interacter.tool = ""
					ui.set_tool("-")
					success = true
			"Treat":
				if interacter.tool == want:
					interacter.tool = ""
					ui.set_tool("-")
					var text_inst = floating_text.instantiate()
					text_inst.set_text("- " + want)
					text_inst.position.x = interacter.position.x
					text_inst.position.y = interacter.position.y - 125
					get_parent().add_child(text_inst)
					success = true
		if success:
			task_manager.pass_task(wants_pos[i])
			wants.remove_at(i)
			wants_pos.remove_at(i)
			"""
			task_inst.queue_free()
			task_inst = null
			"""
			task_cd = max_task_cd
			_on_mask_body_exited(interacter)
			break


func del_want(pos):
	for i in range(0, wants_pos.size() - 1):
		if wants_pos[i] == pos:
			wants.remove_at(i)
			wants_pos.remove_at(i)


func _physics_process(delta):
	velocity.y += grav * delta
	velocity.y = clamp(velocity.y + grav * delta, -max_spd, max_spd)
	move_and_slide()


func _on_mask_body_entered(body):
	#if !task_inst:
	#	return
	interactable.entered(body)
	# Stop the dog from moving while colliding with the player
	hmove = 0
	move_timer = -1


func _on_mask_body_exited(body):
	interactable.exited(body)
	# Allow dog to move once more
	if move_timer == -1:
		move_timer = 1
