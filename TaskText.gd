extends Label

@onready var ui = get_parent().get_parent().get_parent()
@onready var task_manager = get_parent().get_parent().get_parent().get_parent().get_node("TaskManager")
@onready var dog = task_manager.dog

var timer : int = 0
var desc : String = "TASK ERROR"
var pos : int = 0


func _process(_delta):
	timer -= 1
	text = desc + " " + str(ceil(float(timer) / 60.0))
	if timer <= 0:
		task_manager.fail_task(pos)
		dog.del_want(pos)
		ui.del_task(self)
