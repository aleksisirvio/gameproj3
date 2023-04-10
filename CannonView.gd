extends Node


@onready var bg = $Background
@onready var scope = $Scope
@onready var controller = $CannonController
@onready var shoot_player = $ShootPlayer
@onready var hit_player = $HitPlayer
@onready var miss_player = $MissPlayer


func _ready():
	deactivate()


func activate():
	controller.active = true
	for child in get_children():
		if child is ParallaxBackground:
			child.visible = true


func deactivate():
	controller.active = false
	for child in get_children():
		if child is ParallaxBackground:
			child.visible = false


func add_ball(which):
	controller.ball = which


func set_enemy_fortress(which):
	controller.set_enemy_fortress(which)


func is_active():
	return controller.active


func play_hit():
	hit_player.play()
	
	
func play_miss():
	miss_player.play()
	
	
func play_shoot():
	shoot_player.play()
