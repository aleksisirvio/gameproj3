extends ParallaxBackground


var bb : Rect2 = Rect2()

const fortress_size : float = 1000

@onready var sprite = $ParallaxLayer/Sprite2D


func _ready():
	# Starting size and position
	sprite.scale.x = bb.size.x / fortress_size
	sprite.scale.y = bb.size.y / fortress_size
	sprite.position.x = 1920.0 / 2.0
	sprite.position.y = 500
	scroll_offset.x = 1920.0 / 2.0
	scroll_offset.y = 500
	bb = Rect2(scroll_offset.x, 500, 90, 90)


func _process(_delta):
	# TODO: Constantly calculate the position and size of the fortress
	pass
