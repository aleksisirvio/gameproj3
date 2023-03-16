extends CharacterBody2D


"""
Collision bit info:
	1: Player
	2: Dog
	3: Walls
	4: Player interactables (dog, terminal, brush, etc.)
	5: Dog jump launcher
	6: Platforms
	7: Ladders
"""


enum State { move, climb }
var state : State = State.move

const spd 		: int 	= 400
const max_spd	: int	= 1200
const jump_spd 	: int 	= 1200
const grav 		: float = 3000

var hmove : int = 0
var vmove : int = 0
var on_floor : bool = false

var check_target = null	# Who player interacts with upon pressing "interact" key
var tool = ""			# The tool that player is currently holding
var ladder = null


func _ready():
	pass
	
	
func _process(delta):
	# Intention to move
	hmove = 0
	vmove = 0
	if Input.is_action_pressed("left"):
		hmove = -1
	if Input.is_action_pressed("right"):
		if hmove == -1:
			hmove = 0
		else:
			hmove = 1
	if Input.is_action_pressed("up"):
		vmove = -1
	if Input.is_action_pressed("down"):
		if vmove == -1:
			vmove = 0
		else:
			vmove = 1
		
	on_floor = is_on_floor()
	
	# State machine
	match state:
		State.move:
			move()
			velocity.y = clamp(velocity.y + grav * delta, -max_spd, max_spd)
		State.climb:
			climb()
	
	# Interacting with interactables
	if Input.is_action_just_pressed("interact") and check_target:
		check_target.interact(self)
	

func init_move():
	state = State.move


func move():
	velocity.x = hmove * spd
	
	# Jumping
	if Input.is_action_pressed("jump") and on_floor:
		velocity.y = -jump_spd
	
	# Falling through platforms
	if Input.is_action_pressed("down"):
		set_collision_mask_value(6, false)
	else:
		set_collision_mask_value(6, true)
	
	# Climbing up a ladder
	if ladder:
		if Input.is_action_pressed("up") or Input.is_action_pressed("down"):
			init_climb()
	

func init_climb():
	velocity *= 0
	position.x = ladder.position.x
	state = State.climb


func climb():
	velocity.y = vmove * spd
	if Input.is_action_just_pressed("jump") or on_floor:
		init_move()

	
func _physics_process(_delta):
	move_and_slide()
