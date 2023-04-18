extends Node


@onready var ui = get_parent().get_node("UI")
@onready var dog = get_parent().get_node("Dog")
@onready var cannon_view = get_parent().get_node("CannonView")

@onready var enemy_fort = preload("res://EnemyFortress.tscn")
@onready var poop = preload("res://Poop.tscn")
@onready var mouse = preload("res://Mouse.tscn")
@onready var go_to_main_menu = preload("res://GoToMainMenu.tscn")

@onready var task_arrival_player = $TaskArrivalPlayer
@onready var poop_player = $PoopPlayer
@onready var task_success_player = $TaskSuccessPlayer
@onready var task_fail_player = $TaskFailPlayer
@onready var warning_player = $WarningPlayer

enum Task { treat, pet, enemy_fortress, poop, mouse, brush, dance, sing }
const task_durations : Array = [1800, 2500, 4200, 2500, 2500, 2500, 2500, 2500]
const task_icons : Array = [
	preload("res://Sprites/Icons/give dog a treat.png"),
	preload("res://Sprites/Icons/pat the dog.png"),
	preload("res://Sprites/Icons/Attack.png"),
	preload("res://Sprites/Icons/clean up dog poop.png"),
	preload("res://Sprites/Icons/catch a mouse.png"),
	preload("res://Sprites/Icons/grooming.png"),
	preload("res://Sprites/Icons/dance.png"),
	preload("res://Sprites/Icons/karaoke.png")
]
const task_icon_scales : Array = [1.2, 1.5, 1, 1, 1, 1.2, 1, .75]
const task_rewards : Array = [500, 700, 2000, 900, 900, 800, 750, 750]

const max_tasks : int = 3
var current_tasks : int = 0

var tasks : Array = []

const tutorial_task_list : Array = [Task.treat, Task.pet, Task.brush, Task.dance, Task.poop, Task.sing, Task.mouse, Task.enemy_fortress]
var tutorial_task_pos : int = 0
var tutorialize : bool = false

const max_assign_timer : float = 600
var assign_timer : float = 180

var last_assigned : int = -1

const failures_to_game_over : int = 5
var failures : int = 0


func _ready():
	# Initialize task arrays with null values
	tasks.resize(max_tasks)
	tasks.fill(null)


func _process(delta):
	# Assigning new tasks
	if assign_timer > 0:
		if tutorialize:
			if current_tasks == 0:
				assign_timer -= delta * 60
		else:
			assign_timer -= delta * 60
	elif current_tasks < max_tasks:
		# Find empty task spot
		var free_pos = 0
		for i in range(0, max_tasks):
			if tasks[i] == null:
				free_pos = i
				break
		
		var rand = -1
		
		if tutorialize:
			rand = tutorial_task_list[tutorial_task_pos]
		
		else:
			var valid = false
			while !valid:
				rand = randi() % (task_durations.size())
				if has_task(rand) or rand == last_assigned:
					continue
				"""
				if current_tasks == 0:
					rand = Task.treat
				#if current_tasks == 1:
				#	rand = Task.enemy_fortress
				"""
				valid = true
		tasks[free_pos] = rand
		last_assigned = rand
			
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
				desc = "Groom the dog"
				dog.wants.append("Brush")
				dog.wants_pos.append(free_pos)
			
			Task.dance:
				desc = "Dance for the dog"
			
			Task.sing:
				desc = "Sing for the dog"
				
		ui.add_task(desc, task_durations[rand], task_icons[rand], task_icon_scales[rand], free_pos, tutorialize)


func has_task(which):
	for task in tasks:
		if task == which:
			return true
	return false


func pass_task_at(pos):
	ui.add_money(task_rewards[tasks[pos]])
	ui.increment_task_count()
	ui.del_task(pos)
	current_tasks -= 1
	tasks[pos] = null
	task_success_player.play()
	if tutorialize:
		tutorial_task_pos += 1
		assign_timer = 120
		if tutorial_task_pos >= tutorial_task_list.size():
			tutorial_task_pos = 0
			assign_timer = 6000
			var go_to_menu = go_to_main_menu.instantiate()
			get_parent().add_child(go_to_menu)
			go_to_menu.set_text("Tutorial complete!")


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
	elif tasks[pos] == Task.mouse:
		if get_parent().has_node("Mouse"):
			get_parent().get_node("Mouse").queue_free()
	elif tasks[pos] == Task.pet:
		if get_parent().has_node("PettingGame"):
			get_parent().get_node("PettingGame").exit()
	elif tasks[pos] == Task.brush:
		if get_parent().has_node("BrushingGame"):
			get_parent().get_node("BrushingGame").exit()
	elif tasks[pos] == Task.dance:
		if get_parent().has_node("DanceGame"):
			get_parent().get_node("DanceGame").exit()
	elif tasks[pos] == Task.sing:
		if get_parent().has_node("SingingGame"):
			get_parent().get_node("SingingGame").exit()
	tasks[pos] = null
	task_fail_player.play()
	failures += 1
	if failures >= failures_to_game_over:
		# Go back to main menu
		get_parent().get_parent().add_score(ui.money)
		get_parent().add_child(go_to_main_menu.instantiate())


func play_warning():
	warning_player.play()
