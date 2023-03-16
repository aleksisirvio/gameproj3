extends Area2D


var title : String = "Treat"

@onready var interactable = $Interactable

@onready var ui = get_parent().get_node("UI")

@onready var floating_text = preload("res://FloatingText.tscn")


func _on_body_entered(body):
	if body.tool == title:
		return
	interactable.entered(body)


func _on_body_exited(body):
	interactable.exited(body)


func interact(interacter):
	if interacter.tool == title:
		return
	interacter.tool = title
	ui.set_tool(title)
	var text_inst = floating_text.instantiate()
	text_inst.set_text("+ " + title)
	text_inst.position.x = interacter.position.x
	text_inst.position.y = interacter.position.y - 125
	get_parent().add_child(text_inst)
	_on_body_exited(interacter)
