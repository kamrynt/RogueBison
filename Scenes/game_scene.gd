extends Node2D

@onready var main = get_tree().get_root().get_node("Main2D")
@onready var wave_timer: Timer = $WaveTimer

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


func _process(delta: float) -> void:
	roomChangeTimer -= delta


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
