extends Control

func _on_new_game_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/GameScene.tscn")



func _on_continue_btn_pressed() -> void:
	pass # Replace with function body.



func _on_stats_btn_pressed() -> void:
	pass # Replace with function body.



func _on_options_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/OptionsScene.tscn")



func _on_exit_btn_pressed() -> void:
	get_tree().quit()
	
