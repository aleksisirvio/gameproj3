extends ParallaxBackground


@onready var explosion = preload("res://Explosion.tscn")

@onready var sprite = $Sprite2D

var real_x : float = 0

var time_to_target : float = 0
var timer : float = 0
var arcing_time : float = 0

const arc_max_spd : float = 10
const arc_acc : float = .2

var arc_spd : float = -5

var creator = null

var type : String = ""


# Always call this method when creating a cannon ball node
func shoot(who_created, target_pos, what_type):
	type = what_type
	creator = who_created
	time_to_target = 30 + (1350 + target_pos.y * 2) / 20
	timer = time_to_target
	arcing_time = time_to_target - 70
	real_x = 1920.0 / 2.0 - target_pos.x
	
	# Get rid of poop cleaning task if shooting poop
	if type == "Bag Filled With Poop":
		get_parent().get_parent().get_node("TaskManager").pass_task(3)
		get_parent().get_parent().get_node("Player").set_tool("")
		get_parent().get_parent().get_node("UI").set_tool("-")
	
	get_parent().play_shoot()


func _process(delta):
	timer -= delta * 60
	
	# Flying in an arc
	if timer > time_to_target - arcing_time:
		if arc_spd > -arc_max_spd / 2:
			arc_spd -= arc_acc * delta * 60
	else:
		if arc_spd < arc_max_spd:
			arc_spd += arc_acc * delta * 60
		
	sprite.position.y += arc_spd * delta * 60
		
	# Cannon ball size
	sprite.scale.x -= .009 * delta * 60
	sprite.scale.y -= .009 * delta * 60
	
	# Deal damage and destroy
	if timer <= 0:
		# Check manually if colliding with enemy target
		var fortress_exists = creator.get_parent().has_node("EnemyFortress")
		if fortress_exists:
			var target = creator.get_parent().get_node("EnemyFortress")
			var r2 = target.bb
			var clamped_x = sprite.position.x
			while abs(clamped_x) > 1920:
				clamped_x -= sign(clamped_x) * 1920
			var r1 = Rect2(real_x - 5, sprite.position.y - 5, 10, 10)
			var collision = false
			if r1.position.x + r1.size.x >= r2.position.x \
			and r1.position.x <= r2.position.x + r2.size.x \
			and r1.position.y + r1.size.y >= r2.position.y \
			and r1.position.y <= r2.position.y + r2.size.y:
				collision = true
			
			###
			collision = true
			###
			
			if collision:
				if get_parent().is_active():
					var explo_inst = explosion.instantiate()
					explo_inst.offset = sprite.position
					get_parent().add_child(explo_inst)
				if type == "Bag Filled With Poop":
					target.take_damage(100)
				else:
					target.take_damage(1)
				if type == "Bag Filled With Poop":
					get_parent().play_poop_hit()
				else:
					get_parent().play_hit()
			else:
				get_parent().play_miss()
			
			print("")
			print("Ball bb: ", r1)
			print("Fortress bb: ", r2)
			print("Collision: ", collision)
		
		else:
			get_parent().play_miss()
		
		creator.cannon_ball = null
		queue_free()
