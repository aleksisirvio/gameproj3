extends ParallaxBackground


@onready var cannon_ball = preload("res://EnemyCannonBall.tscn")

@onready var controller = get_parent().get_node("CannonController")
@onready var task_manager = get_parent().get_parent().get_node("TaskManager")

var bb : Rect2 = Rect2()

const fortress_size : float = 1000

var origin : Vector2 = Vector2()
var target : Vector2 = Vector2()
var vel : Vector2 = Vector2()

const max_move_cd : float = 300
var move_cd : float = 1

var max_shoot_cd : float = 600
var shoot_cd : float = max_shoot_cd

var hp = 2

@onready var sprite = $Sprite2D
@onready var bg = get_parent().get_node("Background")


func _ready():
	sprite.position.x = 1920.0 / 2.0
	sprite.position.y = 500.0
	#scroll_offset.x = sprite.position.x
	#scroll_offset.y = sprite.position.y
	sprite.scale.x = bb.size.x / fortress_size
	sprite.scale.y = bb.size.y / fortress_size
	origin = sprite.position


func _process(delta):
	# Move
	if move_cd > 0:
		move_cd -= delta * 60
		if move_cd <= 0:
			target.x = origin.x + randi() % 400
			target.y = origin.y + randi() % 150
			move_cd = max_move_cd
			var w = target.x - sprite.position.x
			var h = target.y - sprite.position.y
			var hyp = sqrt(w * w + h * h)
			vel.x = w / hyp * 1.0
			vel.y = h / hyp * 1.0
	sprite.position.x += vel.x * delta * 60
	sprite.position.y += vel.y * delta * 60
	
	# Set visual size
	sprite.scale.x = sprite.position.y / 1500 / 2
	sprite.scale.y = sprite.scale.x
	
	# Set bounding box
	bb = Rect2(sprite.position.x - sprite.scale.x * 1000 / 2, sprite.position.y - sprite.scale.y * 1000 / 2, sprite.scale.x * 1000, sprite.scale.y * 1000)
	
	# Shooting
	shoot_cd -= delta * 60
	if shoot_cd <= 0:
		shoot_cd = max_shoot_cd + randi() % 120
		var cannon_ball_inst = cannon_ball.instantiate()
		cannon_ball_inst.get_node("Sprite2D").position = sprite.position
		cannon_ball_inst.get_node("Sprite2D").scale = Vector2(0,0)
		cannon_ball_inst.offset = offset
		cannon_ball_inst.visible = visible
		cannon_ball_inst.shoot(sprite.position)
		get_parent().add_child(cannon_ball_inst)
		controller.set_enemy_fortress_cannon_ball(cannon_ball_inst)
	

func take_damage(amount):
	hp -= amount
	if hp <= 0:
		controller.set_enemy_fortress(null)
		task_manager.pass_task(2)
		queue_free()
		

func remove():
	controller.set_enemy_fortress(null)
	queue_free()
