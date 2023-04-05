extends Node


@onready var player = get_parent().get_parent().get_node("Player")
@onready var ui = get_parent().get_parent().get_node("UI")
@onready var bg = get_parent().get_node("Background")
@onready var scope = get_parent().get_node("Scope")

var enemy_fortress = null
var cannon_ball = null
var enemy_fortress_cannon_ball = null

@onready var cannon_ball_res = preload("res://CannonBall.tscn")
@onready var flash_res = preload("res://Flash.tscn")


var vel : Vector2 = Vector2()
var acc : float = .2
var max_spd : float = 5

var active : bool = false
var ball : String = ""

var max_shake_timer : float = 60
var shake_timer : float = 0


func _process(delta):
	# Shake (runs even when cannon view is hidden)
	if shake_timer > 0:
		shake_timer -= delta * 60
		scope.offset.x = randf_range(-15, 15)
		scope.offset.y = randf_range(-15, 15)
		if shake_timer <= 0:
			scope.offset = Vector2(0, 0)
	
	if !active:
		return
	
	# Use player hmove and vmove to move cannon
	var hmove = player.hmove
	var vmove = player.vmove
	
	# Calculate cannon turning speed with inertia
	if sign(vel.x) != hmove or abs(vel.x) < max_spd:
		vel.x += hmove * acc * delta * 60
	if sign(vel.y) != vmove or abs(vel.y) < max_spd:
		vel.y += vmove * acc * delta * 60
	if hmove == 0:
		vel.x -= sign(vel.x) * acc * delta * 60
		if abs(vel.x) < .1:
			vel.x = 0
	if vmove == 0:
		vel.y -= sign(vel.y) * acc * delta * 60
		if abs(vel.y) < .1:
			vel.y = 0
	
	# Cannon actually doesn't move, everything else is moved
	bg.scroll_offset.x = clamp(bg.scroll_offset.x - (vel.x * delta * 60), -1920, 1920)
	bg.scroll_offset.y = clamp(bg.scroll_offset.y - (vel.y * delta * 60), -125, 125)
	if bg.scroll_offset.y >= 125 or bg.scroll_offset.y <= -125:
		vel.y = 0
	if bg.scroll_offset.x >= 1920 or bg.scroll_offset.x <= -1920:
		vel.x = 0
	
	if enemy_fortress != null:
		enemy_fortress.offset.x -= vel.x * delta * 60
		enemy_fortress.offset.y -= vel.y * delta * 60
	if cannon_ball != null:
		cannon_ball.offset.x -= vel.x * delta * 60
		cannon_ball.offset.y -= vel.y * delta * 60
		
	if enemy_fortress_cannon_ball != null:
		enemy_fortress_cannon_ball.offset.x -= vel.x * delta * 60
		enemy_fortress_cannon_ball.offset.y -= vel.y * delta * 60
	
	# Shoot the cannon
	if Input.is_action_just_pressed("jump"):
		if cannon_ball == null and ball != "":
			player.tool = ""
			ui.set_tool("-")
			scope.add_child(flash_res.instantiate())
			var cannon_ball_inst = cannon_ball_res.instantiate()
			get_parent().add_child(cannon_ball_inst)
			cannon_ball_inst.shoot(self, bg.scroll_offset, ball)
			cannon_ball = cannon_ball_inst
			ball = ""
	
	# Exit cannon view
	if Input.is_action_just_pressed("interact"):
		vel *= 0
		player.init_move()
		get_parent().deactivate()


func set_enemy_fortress(who):
	enemy_fortress = who


func set_cannon_ball(who):
	cannon_ball = who


func set_enemy_fortress_cannon_ball(who):
	enemy_fortress_cannon_ball = who


func shake():
	shake_timer = max_shake_timer
