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
	8: Mouse
"""

@onready var footstep_player = $FootstepPlayer
@onready var jump_player = $JumpPlayer
@onready var land_player = $LandPlayer

@onready var sprite = $Sprite
@onready var tool_sprite = $Tool

@onready var tool_dict = {
	"Brush": [preload("res://Sprites/Tools/brush.png"), .5],
	"Treat": [preload("res://Sprites/Tools/treat.png"), .5],
	"Bag": [preload("res://Sprites/Tools/empty_poop_bag.png"), .5],
	"Bag Filled With Poop": [preload("res://Sprites/Tools/full_poop_bag.png"), .5],
	"Mouse Catcher": [preload("res://Sprites/Tools/mouse_catcher.png"), .5],
	"Fire Extinguisher": [preload("res://Sprites/Tools/fire_extinguisher.png"), .2]
}

enum State { move, climb, pause }
var state : State = State.move

const spd 		: int 	= 300
const max_spd	: int	= 700
const jump_spd 	: int 	= 700
const grav 		: float = 2000

var hmove : int = 0
var vmove : int = 0
var on_floor : bool = false
var prev_on_floor : bool = false

var targets : Array = []	# All interactables player is colliding with
var tool = ""				# The tool that player is currently holding
var ladder = null

var max_footstep_cd : float = 22
var footstep_cd : float = 0


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
			move(delta)
			velocity.y = clamp(velocity.y + grav * delta, -max_spd, max_spd)
		State.climb:
			climb()
		State.pause:
			pause()
			return # Don't allow interacting while paused
	
	if hmove == 0:
		sprite.play("idle")
		sprite.scale = Vector2(.2, .2)
	else:
		sprite.play("walk")
		sprite.scale = Vector2(.19, .19)
		if hmove == 1:
			sprite.flip_h = true
			tool_sprite.position.x = 20
		if hmove == -1:
			sprite.flip_h = false
			tool_sprite.position.x = -20
	
	# Interacting with interactables
	if Input.is_action_just_pressed("interact"):
		for target in targets:
			var success = target.interact(self)
			if success:
				get_parent().play_success()
			else:
				get_parent().play_fail()
	
	prev_on_floor = on_floor
	

func add_target(target):
	targets.append(target)
	

func remove_target(target_name):
	var i = 0
	while i < targets.size():
		if targets[i].name == target_name:
			targets.remove_at(i)
			i = -1
		i += 1


func init_move():
	state = State.move


func move(delta):
	velocity.x = hmove * spd
	
	# Jumping
	if Input.is_action_pressed("jump") and on_floor:
		velocity.y = -jump_spd
		jump_player.play()
	
	# Falling through platforms
	if Input.is_action_pressed("down"):
		set_collision_mask_value(6, false)
	else:
		set_collision_mask_value(6, true)
	
	# Climbing up a ladder
	if ladder:
		if Input.is_action_pressed("up") or Input.is_action_pressed("down"):
			init_climb()
			
	if on_floor and !prev_on_floor:
		land_player.play()
	
	if hmove != 0 and on_floor:
		footstep_cd -= delta * 60
		if footstep_cd <= 0:
			footstep_cd = max_footstep_cd
			footstep_player.play()
	else:
		footstep_cd = 0
	

func init_climb():
	velocity *= 0
	position.x = ladder.position.x + 90 # This 90 is needed after moving center of the fortress to the right, no idea why
	state = State.climb


func climb():
	velocity.y = vmove * spd
	if Input.is_action_just_pressed("jump") or on_floor:
		init_move()


func init_pause():
	velocity.x = 0
	state = State.pause
	

func pause():
	# Player does nothing while paused
	pass

	
func set_tool(title):
	tool = title
	if tool_dict.has(title):
		tool_sprite.texture = tool_dict.get(title)[0]
		tool_sprite.scale = Vector2(tool_dict.get(title)[1], tool_dict.get(title)[1])
	else:
		tool_sprite.texture = null
	
	
func _physics_process(_delta):
	move_and_slide()
