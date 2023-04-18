extends ParallaxBackground


@onready var flash = preload("res://Flash.tscn")

@onready var sprite = $Sprite2D

var vel : Vector2 = Vector2()
const arc_max_spd : float = 10
const arc_acc : float = .2
var arc_spd : float = -6
var arc_timer : float = 90
var ydist : float = 0


func shoot(pos):
	var xdist = 1920.0 / 2.0 - pos.x
	ydist = 1080.0 / 2.0 - pos.y
	var dist = sqrt(xdist * xdist + ydist * ydist)
	vel.x = xdist / dist
	vel.y = ydist / dist


func _process(delta):
	if arc_timer > 0:
		arc_timer -= delta * 60
	else:
		arc_spd += arc_acc * delta * 60
	
	sprite.position.x += vel.x * delta * 60
	sprite.position.y += vel.y * delta * 60
	sprite.position.y += arc_spd * delta * 60
	sprite.scale.x += .025 * delta * 60
	sprite.scale.y += .025 * delta * 60
	
	if sprite.scale.x >= 4:
		# Shake screen
		get_parent().get_node("CannonController").shake()
		get_parent().get_parent().shake()
		
		# Play sound
		get_parent().play_take_damage()
		
		# Explosive flash if player is in cannon view
		get_parent().get_node("Scope").add_child(flash.instantiate())
		
		# Set a random interactable on fire
		get_parent().get_parent().set_random_interactable_on_fire()
		
		# Destroy
		get_parent().get_node("CannonController").set_enemy_fortress_cannon_ball(null)
		queue_free()
