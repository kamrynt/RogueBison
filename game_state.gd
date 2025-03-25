extends Node

var current_character_id: int = -1
var current_scene: Node = null

func _ready():
	# Add this script to autoload/singleton in project settings
	pass

func start_new_game(player_id: String, character_name: String) -> void:
	# Create new character
	if Database.create_new_character(player_id, character_name):
		# Get the newly created character's ID
		var characters = Database.get_player_characters(player_id)
		if characters.size() > 0:
			current_character_id = characters[-1].CharacterID
			# Start with storybook intro
			change_scene("res://Scenes/storybook_intro.tscn")
	else:
		print("Failed to create new character")

func continue_game(character_id: int) -> void:
	current_character_id = character_id
	var position_data = Database.get_player_position(character_id)
	
	if position_data.has("room"):
		# Load the last room the player was in
		change_scene("res://Scenes/" + position_data.room + ".tscn")
	else:
		# If no saved position, start from storybook intro
		change_scene("res://Scenes/storybook_intro.tscn")

func save_current_position(room_name: String, position: Vector2) -> void:
	if current_character_id == -1:
		return
		
	var position_data = {
		"x": position.x,
		"y": position.y
	}
	
	Database.save_player_position(current_character_id, room_name, position_data)

func change_scene(scene_path: String) -> void:
	# Save current position before changing scene if we have a current character
	if current_character_id != -1 and current_scene != null:
		var player = current_scene.get_node("Player")  # Adjust node path as needed
		if player:
			save_current_position(current_scene.name, player.global_position)
	
	# Change to new scene
	var new_scene = load(scene_path)
	if new_scene:
		get_tree().change_scene_to(new_scene)
		current_scene = get_tree().current_scene
	else:
		print("Failed to load scene: " + scene_path)

func get_current_character() -> Dictionary:
	if current_character_id == -1:
		return {}
	return Database.get_character(current_character_id) 