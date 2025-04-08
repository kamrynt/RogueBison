extends Node2D
class_name Room

#@onready var enemy = load("res://Characters/enemies/robot.tscn")
@onready var main = get_tree().get_root().get_node("Main2D")

enum DoorEnum {NoDoor, NormalDoor, BossDoor, HiddenDoor}
var value: int
var coordinate: Vector2 = Vector2(0,0)

var entered: bool = false
var lastDir
var monsters = []
var cleared : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# spawns monsters
	pass

#func spawnMonsters(target):
	#if main != null and !cleared:
		#for i in range(10):
			#var instance: NPCCharacterBase = enemy.instantiate()
			#instance.set_target(target)
			#instance.global_position = Vector2(randi_range(150, 300),randi_range(150, 300)) + global_position
			#main.add_child.call_deferred(instance)
			#monsters.append(instance)
func destroyMonsters():
	for monster in monsters:
		if monster != null:
			monster.queue_free()

func getDirCoords(dir):
	match dir:
		Globals.N:
			return get_node("TopBox").global_position
		Globals.E:
			return get_node("RightBox").global_position
		Globals.S:
			return get_node("BottomBox").global_position
		Globals.W:
			return get_node("LeftBox").global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if entered and Input.is_action_pressed("ui_accept"):
		entered = false
		Globals.change_rooms.emit(lastDir)

func setInactive():
	destroyMonsters()
	var cam = get_node("Camera2D")
	cam.enabled = false

func setActive(target):
	#spawnMonsters(target)
	var cam = get_node("Camera2D")
	cam.enabled = true
	cam.make_current()

func handleDoorBodyEntered(dir, body):
	#Globals.entered_door_area.emit(dir,body)
	if body is PlayerCharacterBase and (dir & value) != 0:
		entered = true
		lastDir = dir
		
func handleDoorBodyExited( body):
	if body is PlayerCharacterBase:
		entered = false

func _on_top_box_body_entered(body: Node2D) -> void:
	handleDoorBodyEntered(Globals.N, body)
func _on_bottom_box_body_entered(body: Node2D) -> void:
	handleDoorBodyEntered(Globals.S, body)
func _on_left_box_body_entered(body: Node2D) -> void:
	handleDoorBodyEntered(Globals.W, body)
func _on_left_box_2_body_entered(body: Node2D) -> void:
	handleDoorBodyEntered(Globals.E, body)
func _on_top_box_body_exited(body: Node2D) -> void:
	handleDoorBodyExited(body)
func _on_bottom_box_body_exited(body: Node2D) -> void:
	handleDoorBodyExited(body)
func _on_left_box_body_exited(body: Node2D) -> void:
	handleDoorBodyExited(body)
func _on_left_box_2_body_exited(body: Node2D) -> void:
	handleDoorBodyExited(body)
