extends CanvasGroup


var task_count : int = 0

@onready var tasks_text = $Control/Tasks
@onready var tool_text = $Control/Tool


func increment_task_count():
	task_count += 1
	tasks_text.text = "Tasks completed: " + str(task_count)


func get_tool(name):
	tool_text.text = "Tool: " + name
