extends Area2D


@onready var interactable = $Interactable

@onready var ui = get_parent().get_node("UI")
@onready var task_manager = get_parent().get_node("TaskManager")
@onready var player = get_parent().get_node("Player")

@onready var floating_text = preload("res://FloatingText.tscn")
@onready var singing_game = preload("res://SingingGame.tscn")

const title : String = "Microphone"

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
		return
	cd = max_cd
	if interactable.on_fire:
		interactable.interact_on_fire(interacter)
		return
	var text_inst = floating_text.instantiate()
	if interacter.tool == "":
		if task_manager.has_task(7): # Task.sing
			text_inst.set_text("")
			player.init_pause()
			get_parent().toggle_black()
			get_parent().add_child(singing_game.instantiate())
			ret = true
		else:
			text_inst.set_text("No reason to use")
	else:
		text_inst.set_text("Holding " + interacter.tool)
	text_inst.position.x = interacter.position.x
	text_inst.position.y = interacter.position.y - 125
	get_parent().add_child(text_inst)
	return ret
