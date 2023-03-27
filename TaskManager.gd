extends Node


@onready var ui = get_parent().get_node("UI")
@onready var dog = get_parent().get_node("Dog")

enum Task { treat, pet }
const task_durations : Array = [900, 900]

const max_tasks : int = 3
var current_tasks : int = 0

var tasks : Array = []

const max_assign_timer : int = 600
var assign_timer : int = 180

const failures_to_game_over : int = 5
var failures : int = 0


func _ready():
	# Initialize task arrays with null values
	tasks.resize(max_tasks)
	tasks.fill(null)


func _process(_delta):
	# Assigning new tasks
	if assign_timer > 0:
		assign_timer -= 1
	elif current_tasks < max_tasks:
		# Find empty task spot
		var free_pos = 0
		for i in range(0, max_tasks):
			if tasks[i] == null:
				free_pos = i
				break
		var rand = randi() % (task_durations.size())
		tasks[free_pos] = rand
		current_tasks += 1
		assign_timer = max_assign_timer
		
		# Add new task to UI and communicate to other relevat nodes
		var desc = "ERROR"
		match rand:
			Task.treat:
				desc = "Get the dog a treat"
				dog.wants.append("Treat")
				dog.wants_pos.append(free_pos)
			Task.pet:
				desc = "Pet the dog"
				dog.wants.append("Pet")
				dog.wants_pos.append(free_pos)
		ui.add_task(desc, task_durations[rand], free_pos)


func pass_task(pos):
	ui.increment_task_count()
	ui.del_task(pos)
	current_tasks -= 1
	tasks[pos] = null


func fail_task(pos):
	ui.increment_fail_count()
	current_tasks -= 1
	tasks[pos] = null
	failures += 1
	if failures >= failures_to_game_over:
		# Go back to main menu
		get_parent().queue_free()
		get_tree().reload_current_scene()
