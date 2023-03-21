extends Node


@onready var bg = $Background
@onready var scope = $Scope
@onready var controller = $CannonController


func _ready():
	deactivate()


func activate():
	controller.active = true
	bg.visible = true
	scope.visible = true
	if has_node("EnemyFortress"):
		$EnemyFortress.visible = true
	if has_node("CannonBall"):
		$CannonBall.visible = true


func deactivate():
	controller.active = false
	bg.visible = false
	scope.visible = false
	if has_node("EnemyFortress"):
		$EnemyFortress.visible = false
	if has_node("CannonBall"):
		$CannonBall.visible = false


func add_ball():
	controller.has_ball = true
