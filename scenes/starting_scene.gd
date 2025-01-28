extends Control

func _input(event):
	if event.is_pressed():  # Detect any key press
		_go_to_menu_scene()

func _go_to_menu_scene():
	# Replace 'res://Scenes/menu_scene.tscn' with the actual path to your menu scene
	#var menu_scene = load("res://Scenes/MenuScene.tscn")
	get_tree().change_scene_to_file("res://scenes/MenuScene.tscn")
