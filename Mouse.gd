extends CharacterBody2D

@onready var interactable = $Interactable

@onready var floating_text = preload("res://FloatingText.tscn")

@onready var ui = get_parent().get_node("UI")

@onready var sprite = $Sprite

const spd : float = 500
const jump_spd : float = 750
const grav : float = 2000

var hmove : float = 0

var jump_cd : float = randi_range(60, 180)

var up_stairs : bool = false

const title : String = "Mouse"

const max_cd : float = 30
var cd : float = 0

var player_col = null


func _ready():
	if randi() % 1 == 0:
		hmove = -1
		sprite.flip_h = true
	else:
		hmove = 1
		sprite.flip_h = false
	sprite.play()

func _process(delta):
	if cd > 0:
		cd -= delta * 60
	if jump_cd > 0:
		jump_cd -= delta * 60
		if jump_cd <= 0:
			jump_cd = randi_range(60, 180)
			velocity.y = -jump_spd
	if abs(velocity.x) < spd:
		hmove = -hmove
		sprite.flip_h = !sprite.flip_h
	velocity.x = hmove * spd


func _physics_process(delta):
	velocity.y += grav * delta
	# Calculate collision with player without any physical push
	set_collision_mask_value(1, true)
	var ret = move_and_collide(Vector2(0,0), true)
	if ret:
		if player_col == null and ret.get_collider().name == "Player":
			player_col = ret.get_collider()
			_on_body_entered(ret.get_collider())
	elif player_col != null:
		_on_body_exited(player_col)
		player_col = null
	set_collision_mask_value(1, false)
	move_and_slide()


func _on_body_entered(body):
	interactable.entered(body)


func _on_body_exited(body):
	interactable.exited(body)


func interact(interacter):
	var ret = false
	if cd > 0:
		return false
	cd = max_cd
	var text_inst = floating_text.instantiate()
	if interacter.tool == "Mouse Catcher":
		interacter.tool = "Caught Mouse"
		ui.set_tool("Caught Mouse")
		text_inst.set_text("+ Caught Mouse")
		_on_body_exited(player_col)
		queue_free()
		ret = true
	elif interacter.tool == "":
		text_inst.set_text("Need mouse catcher")
	else:
		text_inst.set_text("Holding " + interacter.tool)
	text_inst.position.x = interacter.position.x
	text_inst.position.y = interacter.position.y - 125
	get_parent().add_child(text_inst)
	return ret
