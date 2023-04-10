extends Node


@onready var ui = get_parent().get_node("UI")
@onready var dog = get_parent().get_node("Dog")
@onready var cannon_view = get_parent().get_node("CannonView")

@onready var enemy_fort = preload("res://EnemyFortress.tscn")
@onready var poop = preload("res://Poop.tscn")
@onready var mouse = preload("res://Mouse.tscn")

@onready var task_arrival_player = $TaskArrivalPlayer
@onready var poop_player = $PoopPlayer
@onready var task_success_player = $TaskSuccessPlayer
@onready var task_fail_player = $TaskFailPlayer
@onready var warning_player = $WarningPlayer

enum Task { treat, pet, enemy_fortress, poop, mouse, brush, dance, sing }
const task_durations : Array = [1800, 2500, 4200, 2500, 2500, 2500, 2500, 2500]

const max_tasks : int = 3
var current_tasks : int = 0

var tasks : Array = []

const max_assign_timer : float = 600
var assign_timer : float = 180

const failures_to_game_over : int = 5
var failures : int = 0


func _ready():
	# Initialize task arrays with null values
	tasks.resize(max_tasks)
	tasks.fill(null)


func _process(delta):
	# Assigning new tasks
	if assign_timer > 0:
		assign_timer -= delta * 60
	elif current_tasks < max_tasks:
		# Find empty task spot
		var free_pos = 0
		for i in range(0, max_tasks):
			if tasks[i] == null:
				free_pos = i
				break
				
		var valid = false
		var rand = -1
		while !valid:
			rand = randi() % (task_durations.size())
			if has_task(rand):
				continue
			"""
			if current_tasks == 0:
				rand = Task.poop
			#if current_tasks == 1:
			#	rand = Task.poop
			"""
			tasks[free_pos] = rand
			valid = true
			
		current_tasks += 1
		assign_timer = max_assign_timer
		task_arrival_player.play()
		
		# Add new task to UI and communicate to other relevant nodes
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
				
			Task.enemy_fortress:
				desc = "Defeat enemy fortress"
				var enemy_fort_inst = enemy_fort.instantiate()
				if !cannon_view.is_active():
					enemy_fort_inst.visible = false
				cannon_view.add_child(enemy_fort_inst)
				cannon_view.set_enemy_fortress(enemy_fort_inst)
				
			Task.poop:
				desc = "Clean the dog poop"
				var poop_inst = poop.instantiate()
				poop_inst.position = dog.position
				get_parent().add_child(poop_inst)
				poop_player.play()
				
			Task.mouse:
				desc = "Catch the mouse"
				var mouse_inst = mouse.instantiate()
				# Randomize mouse spawn position
				if randi() % 2 == 0:
					if randi() % 2 == 0:
						mouse_inst.position = Vector2(490, 470)
					else:
						mouse_inst.position = Vector2(1360, 270)
				else:
					if randi() % 2 == 0:
						mouse_inst.position = Vector2(1250, 580)
					else:
						mouse_inst.position = Vector2(1250, 850)
				get_parent().add_child(mouse_inst)
				
			Task.brush:
				desc = "Brush the dog"
				dog.wants.append("Brush")
				dog.wants_pos.append(free_pos)
			
			Task.dance:
				desc = "Dance for the dog"
			
			Task.sing:
				desc = "Grab the mic and sing for the dog"
				
		ui.add_task(desc, task_durations[rand], free_pos)


func has_task(which):
	for task in tasks:
		if task == which:
			return true
	return false


func pass_task_at(pos):
	ui.increment_task_count()
	ui.del_task(pos)
	current_tasks -= 1
	tasks[pos] = null
	task_success_player.play()


func pass_task(which):
	var index = tasks.find(which)
	if index == -1:
		return
	pass_task_at(index)


func fail_task(pos):
	ui.increment_fail_count()
	current_tasks -= 1
	if tasks[pos] == Task.enemy_fortress:
		if cannon_view.has_node("EnemyFortress"):
			cannon_view.get_node("EnemyFortress").remove()
	tasks[pos] = null
	task_fail_player.play()
	failures += 1
	if failures >= failures_to_game_over:
		# Go back to main menu
		get_parent().queue_free()
		get_tree().reload_current_scene()


func play_warning():
	warning_player.play()
