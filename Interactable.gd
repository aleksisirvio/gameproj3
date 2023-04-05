extends Node


@onready var check = preload("res://Check.tscn")
@onready var floating_text = preload("res://FloatingText.tscn")
@onready var fire = preload("res://Fire.tscn")

var check_inst = null

var on_fire : bool = false


func entered(body):
	# Signal player that they can interact
	check_inst = check.instantiate()
	body.add_child(check_inst)
	check_inst.position.y -= 75
	body.add_target(get_parent())


func exited(body):
	# Signal player that they can no longer interact
	if check_inst:
		check_inst.queue_free()
		check_inst = null
	body.remove_target(get_parent().name)


func set_on_fire():
	if on_fire:
		return
	on_fire = true
	get_parent().add_child(fire.instantiate())


func interact_on_fire(interacter):
	var text_inst = floating_text.instantiate()
	if interacter.tool == "Fire Extinguisher":
		text_inst.set_text("Fire has been put out!")
		get_parent().get_node("Fire").queue_free()
		on_fire = false
	else:
		text_inst.set_text("Need Fire Extinguisher!")
	text_inst.position.x = interacter.position.x
	text_inst.position.y = interacter.position.y - 125
	get_parent().get_parent().add_child(text_inst)
