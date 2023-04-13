extends Node2D

@onready var black = $Black
@onready var sky = $Sky
@onready var interact_success_player = $InteractSuccessPlayer
@onready var interact_fail_player = $InteractFailPlayer

@onready var interactables : Array = [
	$CannonBallRack,
	$Treat,
	$PoopBag,
	$MouseCatcher,
	$Brush,
	$DancePad
]

var max_shake_timer : float = 60
var shake_timer : float = 0


func _process(delta):
	# Shaking after cannon ball hit
	if shake_timer > 0:
		shake_timer -= delta * 60
		position.x = randf_range(-15.0, 15.0)
		position.y = randf_range(-15.0, 15.0)
		if shake_timer <= 0:
			position = Vector2(0.0, 0.0)
	
	# Parallax scrolling sky
	sky.scroll_offset.x -= .5 * 60 * delta


func shake():
	shake_timer = max_shake_timer


func set_random_interactable_on_fire():
	var rand = randi_range(0, interactables.size() - 1)
	interactables[rand].get_node("Interactable").set_on_fire()


func toggle_black():
	if black.modulate.a < .25:
		black.modulate.a = .5
	else:
		black.modulate.a = 0


func play_success():
	interact_success_player.play()


func play_fail():
	interact_fail_player.play()
