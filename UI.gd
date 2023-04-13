#extends CanvasGroup
extends ParallaxBackground


var completed_tasks : int = 0
var failed_tasks : int = 0

var money : int = 0

@onready var completed_text = $Control/TasksCompleted
@onready var failed_text = $Control/TasksFailed
@onready var tool_text = $Control/Tool
@onready var test = $Control/Test
@onready var current_tasks_node = $Control/CurrentTasks
@onready var fps_text = $Control/FPS
@onready var money_text = $Control/MoneyText

@onready var task_text_res = preload("res://TaskText.tscn")


func _process(_delta):
	fps_text.text = str(Engine.get_frames_per_second())


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


func add_task(desc, timer, icon, icon_scale, pos):
	var inst = task_text_res.instantiate()
	current_tasks_node.add_child(inst)
	inst.title_label.text = desc
	inst.icon.texture = icon
	inst.icon.scale = Vector2(icon_scale, icon_scale)
	inst.max_timer = timer
	inst.timer = timer
	inst.pos = pos
	#inst.position.x -= offset.x
	#inst.position.y += 10 + (pos) * (251 - 3)
	inst.position.x = 1920.0 / 2.0 - 340.0 / 2.0
	inst.position.y = 1080.0 / 2.0 - offset.y - 600.0
	inst.final_pos.x = 0
	inst.final_pos.y = 80 + 20 + (pos - 1) * (251 - 3)

	
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


func add_money(amount):
	money += amount
	money_text.text = str(money) + "€"
	
