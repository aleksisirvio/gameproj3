extends Node


@onready var bg = $Background
@onready var scope = $Scope
@onready var controller = $CannonController


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
