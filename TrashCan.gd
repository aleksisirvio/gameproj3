extends Area2D


@onready var interactable = $Interactable

@onready var ui = get_parent().get_node("UI")
@onready var task_manager = get_parent().get_node("TaskManager")

@onready var floating_text = preload("res://FloatingText.tscn")

const title : String = "Trash Can"

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
	if interacter.tool == "Bag Filled With Poop":
		interacter.tool = ""
		ui.set_tool("")
		text_inst.set_text("- Bag Filled With Poop")
		task_manager.pass_task(3)
	else:
		text_inst.set_text("Need trash")
	text_inst.position.x = interacter.position.x
	text_inst.position.y = interacter.position.y - 125
	get_parent().add_child(text_inst)
