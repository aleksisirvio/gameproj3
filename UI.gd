extends CanvasGroup


var task_count : int = 0

@onready var tasks_text = $Control/Label


func increment_task_count():
	task_count += 1
	tasks_text.text = "Tasks completed: " + str(task_count)
