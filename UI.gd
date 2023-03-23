#extends CanvasGroup
extends ParallaxBackground


var completed_tasks : int = 0
var failed_tasks : int = 0

@onready var completed_text = $Control/TasksCompleted
@onready var failed_text = $Control/TasksFailed
@onready var tool_text = $Control/Tool
@onready var test = $Control/Test
@onready var current_tasks_node = $Control/CurrentTasks

@onready var task_text_res = preload("res://TaskText.tscn")


func set_test(txt):
	test.text = txt


func increment_task_count():
	completed_tasks += 1
	completed_text.text = "Tasks completed: " + str(completed_tasks)


func increment_fail_count():
	failed_tasks += 1
	failed_text.text = "Tasks failed: " + str(failed_tasks) + "/5"


func set_tool(tool):
	tool_text.text = "Tool: " + tool


func add_task(desc, timer, pos):
	var inst = task_text_res.instantiate()
	inst.desc = desc + ": "
	inst.text = desc + ": "+ str(timer)
	inst.timer = timer
	inst.pos = pos
	inst.position.x += 20
	inst.position.y += 10 + (pos + 1) * 50
	current_tasks_node.add_child(inst)

	
func del_task(who):
	if typeof(who) == TYPE_INT:
		for child in current_tasks_node.get_children():
			if child.name == "Title":
				continue
			if child.pos == who:
				child.queue_free()
				break
	else:
		who.queue_free()
