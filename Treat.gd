extends Area2D


@onready var interactable = $Interactable

@onready var ui = get_parent().get_node("UI")

@onready var floating_text = preload("res://FloatingText.tscn")

const title : String = "Treat"

const max_cd : float = 30
var cd : float = 0


func _process(delta):
	if cd > 0:
		cd -= delta * 60


func _on_body_entered(body):
	interactable.entered(body)


func _on_body_exited(body):
	interactable.exited(body)


func interact(interacter):
	if cd > 0:
		return
	cd = max_cd
	var text_inst = floating_text.instantiate()
	if interacter.tool == title:
		interacter.tool = ""
		ui.set_tool("-")
		text_inst.set_text("- " + title)
	elif interacter.tool == "":
		interacter.tool = title
		ui.set_tool(title)
		text_inst.set_text("+ " + title)
	else:
		text_inst.set_text("Holding " + interacter.tool)
	text_inst.position.x = interacter.position.x
	text_inst.position.y = interacter.position.y - 125
	get_parent().add_child(text_inst)
