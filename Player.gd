extends CharacterBody2D


"""
Collision bit info:
	1: Player
	2: Dog
	3: Walls
	4: Player interactables (dog, terminal, brush, etc.)
	5: Dog jump launcher
"""


const spd 		: int 	= 400
const max_spd	: int	= 1200
const jump_spd 	: int 	= 1200
const grav 		: float = 1500

var check_target	# Who player interacts with upon pressing "interact" key
var tool			# The tool that player is currently holding


func _ready():
	pass
	
	
func _process(_delta):
	# Horizontal movement
	var hmove = 0
	if Input.is_action_pressed("left"):
		hmove = -1
	if Input.is_action_pressed("right"):
		if hmove == -1:
			hmove = 0
		else:
			hmove = 1
	velocity.x = hmove * spd
	
	# Jumping
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -jump_spd
	
	# Interacting with interactables
	if Input.is_action_just_pressed("interact") and check_target:
		check_target.interact(self)
	
	
func _physics_process(delta):
	velocity.y += grav * delta
	velocity.y = clamp(velocity.y + grav * delta, -max_spd, max_spd)
	move_and_slide()
