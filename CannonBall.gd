extends ParallaxBackground


@onready var sprite = $ParallaxLayer/Sprite2D

var time_to_target : int = 0
var timer : int = 0
var arcing_time : int = 0

const arc_max_spd : float = 10
const arc_acc : float = .2

var arc_spd : float = -5

var creator = null


# Always call this method when creating a cannon ball node
func shoot(who_created, target_pos):
	creator = who_created
	time_to_target = 30 + (1350 + target_pos.y * 2) / 20
	timer = time_to_target
	arcing_time = time_to_target - 70
	print("")
	print("Target pos ", target_pos)
	print("Time to target: ", time_to_target)
	print("Arcing time: ", arcing_time)
	#scroll_offset.x = target_pos.x


func _process(_delta):
	timer -= 1
	
	# Flying in an arc
	if timer > time_to_target - arcing_time:
		if arc_spd > -arc_max_spd / 2:
			arc_spd -= arc_acc
	else:
		if arc_spd < arc_max_spd:
			arc_spd += arc_acc
		
	sprite.position.y += arc_spd
		
	# Cannon ball size
	sprite.scale.x -= .009
	sprite.scale.y -= .009
	
	# Deal damage and destroy
	if timer <= 0:
		# Check manually if colliding with enemy target
		var target = creator.get_parent().get_node("EnemyFortress")
		var r2 = target.bb
		var clamped_x = sprite.position.x
		while abs(clamped_x) > 1920:
			clamped_x -= sign(clamped_x) * 1920
		var r1 = Rect2(scroll_offset.x, sprite.position.y, 50, 50)
		var collision = false
		if r1.position.x + r1.size.x >= r2.position.x \
		and r1.position.x <= r2.position.x + r2.size.x \
		and r1.position.y + r1.size.y >= r2.position.y \
		and r1.position.y <= r2.position.y + r2.size.y:
			collision = true
		print("")
		print("Ball bb: ", r1)
		print("Fortress bb: ", r2)
		print("Collision: ", collision)
		
		creator.cannon_ball = null
		queue_free()
