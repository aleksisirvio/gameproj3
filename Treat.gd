extends Area2D


@onready var interactable = $Interactable

@onready var ui = get_parent().get_node("UI")


func _on_body_entered(body):
	interactable.entered(body)


func _on_body_exited(body):
	interactable.exited(body)


func interact(interacter):
	interacter.tool = "Treat"
	ui.get_tool("Treat")
