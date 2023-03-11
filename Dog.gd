extends CharacterBody2D


const spd 		: int 	= 100
const max_spd	: int	= 1200
const jump_spd 	: int 	= 1200
const grav 		: float = 1500

var max_move_timer	: int	= 180
var move_timer		: int	= 1
var hmove			: int	= 0

@onready var interactable = $Interactable

@onready var dog_task = preload("res://DogTask.tscn")
@onready var check = preload("res://Check.tscn")


func _ready():
	# Create initial task
	var task_inst = dog_task.instantiate()
	add_child(task_inst)
	task_inst.position.y -= 80
	
	
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
	velocity.x = hmove * spd


func jump():
	velocity.y = -jump_spd


func _physics_process(delta):
	velocity.y += grav * delta
	velocity.y = clamp(velocity.y + grav * delta, -max_spd, max_spd)
	move_and_slide()


func _on_mask_body_entered(body):
	interactable.entered(body)
	# Stop the dog from moving while colliding with the player
	hmove = 0
	move_timer = -1


func _on_mask_body_exited(body):
	interactable.exited(body)
	# Allow dog to move once more
	move_timer = 1
