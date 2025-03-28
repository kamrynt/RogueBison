
extends Node2D
@onready var main = get_tree().get_root().get_node("Main2D")

var mapGenerator = preload("res://Scenes/Rooms/MapGenerator.gd").new()
var roomChangeMinDelay = 0.5
var roomChangeTimer = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var generated_scene = mapGenerator.generate()
	var current_scene = get_tree().current_scene
	if current_scene:
		current_scene.add_child(generated_scene)
		current_scene.move_child(generated_scene, 0)
	else:
		print("No current scene found.")
	
	mapGenerator.spawnRoom.setActive(%Character)
	Globals.change_rooms.connect(handleRoomChange)
	Globals.hoverItem.connect(handleHoverItem)
	pass # Replace with function body.

func handleRoomChange(dir):
	if roomChangeTimer > 0: return
	roomChangeTimer = roomChangeMinDelay
	var adjRoom = mapGenerator.getAdjacentRoom(dir)
	if adjRoom is Room:
		mapGenerator.currentRoom.setInactive()
		mapGenerator.currentRoom = adjRoom
		adjRoom.setActive(%Character)
		var pos = adjRoom.getDirCoords(Globals.OPPOSITE[dir])
		get_node("Character").global_position = pos
		print(adjRoom)

func handleHoverItem(item: ItemBase):
	if item != null:
		print(item.itemName)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	roomChangeTimer -= delta
