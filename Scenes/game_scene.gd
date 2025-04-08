extends Node2D

@onready var main = get_tree().get_root().get_node("Main2D")
@onready var wave_timer: Timer = $WaveTimer
var companion_scene = preload("res://Characters/base/Companion.tscn")
var companion_instance: Node = null
@onready var player = %Character  # Or use $Character if not using unique names
@onready var companion_ui = $SummonUI

var mapGenerator = preload("res://Scenes/Rooms/MapGenerator.gd").new()
var roomChangeMinDelay := 0.5
var roomChangeTimer := 0.0

# === ENEMY SPAWNING ===
var enemy_scene = preload("res://Characters/enemies/enemy.tscn")
var spawn_count := 0
var total_enemies := 20
var waves := [5, 4, 3, 3, 3, 2]
var current_wave := 0

func _ready() -> void:
	var generated_scene = mapGenerator.generate()
	var current_scene = get_tree().current_scene
	if current_scene:
		current_scene.add_child(generated_scene)
		current_scene.move_child(generated_scene, 0)
	else:
		print("No current scene found.")

	mapGenerator.spawnRoom.setActive(%Character)

	Globals.change_rooms.connect(Callable(self, "handleRoomChange"))
	wave_timer.timeout.connect(Callable(self, "_on_WaveTimer_timeout"))

	_on_WaveTimer_timeout()  # Start the first wave immediately
	companion_ui.mode_selected.connect(_on_companion_mode_selected)
	
	
func handleRoomChange(dir):
	if roomChangeTimer > 0.0:
		return
	roomChangeTimer = roomChangeMinDelay

	var adjRoom = mapGenerator.getAdjacentRoom(dir)
	if adjRoom is Room:
		mapGenerator.currentRoom.setInactive()
		mapGenerator.currentRoom = adjRoom
		adjRoom.setActive(%Character)

		var pos = adjRoom.getDirCoords(Globals.OPPOSITE[dir])
		%Character.global_position = pos
		print(adjRoom)
		
	if companion_instance and is_instance_valid(companion_instance):
		companion_instance.queue_free()

	companion_instance = null



func _process(delta: float) -> void:
	roomChangeTimer -= delta
	
	if Input.is_action_just_pressed("summon_companion"):
		companion_ui.toggle_panel()


func _on_WaveTimer_timeout() -> void:
	if current_wave >= waves.size():
		wave_timer.stop()
		return

	var count = waves[current_wave]
	for i in range(count):
		if spawn_count >= total_enemies:
			break

		var enemy = enemy_scene.instantiate()

		# Spawn near top-left of the current room
		var spawn_x = randf_range(40, 100)
		var spawn_y = randf_range(40, 100)
		var spawn_pos = mapGenerator.currentRoom.global_position + Vector2(spawn_x, spawn_y)

		enemy.global_position = spawn_pos
		mapGenerator.currentRoom.add_child(enemy)
		spawn_count += 1

	current_wave += 1
	wave_timer.wait_time = 30
	wave_timer.start()
func _on_companion_mode_selected(mode: String):
	if companion_instance:
		return

	companion_instance = companion_scene.instantiate()
	companion_instance.player = player.get_path()
	companion_instance.global_position = player.global_position + Vector2(40, 0)

	if mode == "attacker":
		print("🗡️ Summoning attacker")
		companion_instance.mode = "attacker"
		# No need to enable healer
	elif mode == "healer":
		print("💖 Summoning healer")
		companion_instance.mode = "healer"
		var healer = companion_instance.get_node_or_null("HealerBehavior")
		if healer:
			healer.set_process(true)
	add_child(companion_instance)
	
