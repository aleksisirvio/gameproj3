extends ParallaxBackground


@onready var sprite = $Sprite
@onready var hit_color = $HitColor
@onready var miss_color = $MissColor

var dir = randi() % 4


func _ready():
	hit_color.modulate.a = 0
	miss_color.modulate.a = 0
	
	match dir:
		0:
			sprite.texture = load("res://Sprites/dance_left.png")
		1:
			sprite.texture = load("res://Sprites/dance_right.png")
		2:
			sprite.texture = load("res://Sprites/dance_down.png")
		3:
			sprite.texture = load("res://Sprites/dance_up.png")


func _process(delta):
	if hit_color.modulate.a > 0:
		hit_color.modulate.a -= .1 * delta * 60
	if miss_color.modulate.a > 0:
		miss_color.modulate.a -= .1 * delta * 60


func try(which):
	if which == dir:
		hit_color.modulate.a = 1
		sprite.modulate.a = .5
		get_parent().increment()
	else:
		miss_color.modulate.a = 1
		get_parent().decrement()
