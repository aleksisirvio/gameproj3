extends Node


@onready var check = preload("res://Check.tscn")
var check_inst = null


func entered(body):
	# Signal player that they can interact
	check_inst = check.instantiate()
	body.add_child(check_inst)
	check_inst.position.y -= 75
	body.check_target = get_parent()


func exited(body):
	# Signal player that they can no longer interact
	if check_inst:
		check_inst.queue_free()
		check_inst = null
	body.check_target = ""
