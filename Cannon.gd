extends Area2D


@onready var interactable = $Interactable

@onready var player = get_parent().get_node("Player")

@onready var cannon_view = get_parent().get_node("CannonView")

var title : String = "Cannon"


func _on_body_entered(body):
	interactable.entered(body)


func _on_body_exited(body):
	interactable.exited(body)


func interact(_interacter):
	# Pause player
	player.init_pause()
	
	# Add player's cannon ball to the cannon
	if player.tool == "Cannon Ball":
		cannon_view.add_ball("Cannon Ball")
	elif player.tool == "Bag Filled With Poop":
		cannon_view.add_ball("Bag Filled With Poop")
	
	# Open cannon view
	cannon_view.activate()
	
	Input.action_release("interact")
	
	return true
