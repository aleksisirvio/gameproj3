extends Area2D


@onready var interactable = $Interactable

@onready var ui = get_parent().get_node("UI")

@onready var floating_text = preload("res://FloatingText.tscn")

const title : String = "Bag Filled With Poop"

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
	var ret = false
	if cd > 0:
		return false
	cd = max_cd
	var text_inst = floating_text.instantiate()
	if interacter.tool == "Bag":
		interacter.tool = title
		ui.set_tool(title)
		text_inst.set_text("+ " + title)
		queue_free()
		ret = true
	elif interacter.tool == "":
		text_inst.set_text("Need bag!")
	else:
		text_inst.set_text("Holding " + interacter.tool)
	text_inst.position.x = interacter.position.x
	text_inst.position.y = interacter.position.y - 125
	get_parent().add_child(text_inst)
	return ret
