extends Control

@onready var ui = get_parent().get_parent().get_parent()
@onready var task_manager = get_parent().get_parent().get_parent().get_parent().get_node("TaskManager")
@onready var dog = task_manager.dog

@onready var yellow_bar = preload("res://Sprites/task_bar_yellow.png")
@onready var red_bar = preload("res://Sprites/task_bar_red.png")

@onready var bar = $Bar
@onready var icon = $Icon
@onready var title_label = $Title
@onready var timer_label = $Timer

var final_pos : Vector2 = Vector2()
var move_timer : float = 60
var vel : Vector2 = Vector2()
var in_place : bool = false

var timer : float = 0
var max_timer : float = 0
var desc : String = "TASK ERROR"
var pos : int = 0
var warning_played : bool = false
var yellow : bool = false


func _process(delta):
	# Set bar size and timer text
	timer -= delta * 60
	timer_label.text = str(ceil(float(timer) / 60.0))
	bar.scale.x = timer / max_timer * 262
	
	# Initial movement
	if move_timer > 0:
		move_timer -= delta * 60
		if move_timer <= 0:
			var xdist = final_pos.x - position.x
			var ydist = final_pos.y - position.y
			var dist = sqrt(xdist * xdist + ydist * ydist)
			vel.x = xdist / dist * 25
			vel.y = ydist / dist * 25
	
	if !in_place:
		position.x += vel.x * delta * 60
		position.y += vel.y * delta * 60
		if abs(position.x - final_pos.x) < 10 and abs(position.y - final_pos.y) < 10:
			in_place = true
			position = final_pos
	
	# Warnings and failure
	if !yellow and timer <= 1200:
		yellow = true
		bar.texture = yellow_bar
	if !warning_played and timer <= 600:
		warning_played = true
		task_manager.play_warning()
		bar.texture = red_bar
	if timer <= 0:
		task_manager.fail_task(pos)
		dog.del_want(pos)
		ui.del_task(self)
