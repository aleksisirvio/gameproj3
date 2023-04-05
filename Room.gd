extends Node2D


@onready var interactables : Array = [
	$CannonBallRack,
	$Treat,
	$PoopBag,
]

var max_shake_timer : float = 60
var shake_timer : float = 0


func _process(delta):
	if shake_timer > 0:
		shake_timer -= delta * 60
		position.x = randf_range(-15.0, 15.0)
		position.y = randf_range(-15.0, 15.0)
		if shake_timer <= 0:
			position = Vector2(0.0, 0.0)


func shake():
	shake_timer = max_shake_timer


func set_random_interactable_on_fire():
	var rand = randi_range(0, interactables.size() - 1)
	interactables[rand].get_node("Interactable").set_on_fire()
