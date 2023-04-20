extends Node2D


@onready var main_menu = $MainMenu

var scores = [0,0,0,0,0,0,0,0,0]


func _ready():
	randomize()
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), .5)
	load_scores()
	main_menu.set_scores()


func _process(_delta):
	# Fullscreen toggling with 'F'
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(Vector2(DisplayServer.screen_get_size() / 2))
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	# Exitting the game
	if Input.is_action_just_pressed("menu"):
		if has_node("MainMenu"):
			save_scores()
			get_tree().quit()
		elif has_node("Room"):
			get_node("Room").queue_free()
			get_tree().reload_current_scene()


func add_score(new_score):
	for i in range(0, scores.size()):
		if new_score > scores[i]:
			# Move all scores down
			var j = scores.size() - 1
			while j > i:
				scores[j]= scores[j-1]
				j -= 1
			scores[i] = new_score
			break
	save_scores()


func load_scores():
	var save_file = FileAccess.open("user://servethedog.save", FileAccess.READ)
	if save_file == null:
		return
	scores.clear()
	while true:
		var line = save_file.get_line()
		if line == "":
			break
		scores.append(int(line))
	save_file.close()


func save_scores():
	var save_file = FileAccess.open("user://servethedog.save", FileAccess.WRITE)
	for score in scores:
		save_file.store_line(str(score))
	save_file.close()
