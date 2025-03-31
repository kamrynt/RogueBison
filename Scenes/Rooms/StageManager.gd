extends Resource

var mazeGenerator: MazeGenerator = preload("res://Scenes/Rooms/MazeGenerator.gd").new()
@export var width: int = 9
@export var height: int = 5
@export var spawnRoomCoords: Vector2 = Vector2(-1,-1)
@export var bossRoomCoords: Vector2 = Vector2(-1,-1)
@export var rewardRoomCoords: Vector2 = Vector2(-1,-1)
@export var maxDepth: int = 4
@export var minCellCount: int = 10
@export var minTryCount: int = 5
var spawnRoom: Room
var currentRoom: Room
var rooms: Dictionary = {}
var normal_room_paths: Array[String] = []
var boss_room_path: String
var reward_room_path: String
func _init(w = null,h = null) -> void:
	if w != null:
		width = w
	if h != null:
		height = h
	mazeGenerator.width = width
	mazeGenerator.height = height

func randomVec2() -> Vector2:
	return Vector2(randi_range(0,width),randi_range(0,height))

func getAdjacentRoom(dir):
	var x = currentRoom.coordinate.x + Globals.DX[dir]
	var y = currentRoom.coordinate.y + Globals.DY[dir]
	var coord_key = str(x) + "," + str(y)
	return rooms[coord_key]
	
# generate and return node that contains the map of the entire stage
# takes in path to stage folder to generate maps out of
func generate(stageName):
	if stageName == "Stage1":
		var path = "res://Scenes/Rooms/Stages/Stage1/"
		normal_room_paths = [
			path + "Normal_01.tscn",
			path + "Normal_02.tscn",
			path + "Normal_03.tscn"
		]
		boss_room_path = path + "BossRoom.tscn"
		reward_room_path = path + "RewardRoom.tscn"
	elif stageName == "Stage2":
		pass
	else:
		print("stageName not set in StageManager.generate")
	var succ = _generate(0)
	var counter = 0
	while !succ and counter < 100:
		randomize()
		counter += 1
		succ = _generate(0)
	return buildScene()
	
	
func buildScene():
	var root = Node2D.new()
	print(rewardRoomCoords)
	for y in height:
		for x in width:
			if mazeGenerator.grid[y][x] != 0:
				
				var randRoom = normal_room_paths.pick_random()
				
				if bossRoomCoords == Vector2(x,y):
					randRoom = boss_room_path
				elif rewardRoomCoords == Vector2(x,y):
					randRoom = reward_room_path
				
				var room: Room = load(randRoom).instantiate()
					
				room.coordinate = Vector2(x,y)
				room.value = mazeGenerator.grid[y][x]
				room.position = Vector2(x,y) - spawnRoomCoords
				var coord_key = str(x) + "," + str(y)
				rooms[coord_key] = room
				if room.position.length() == 0:
					spawnRoom = room
					currentRoom = room
				var tileMap: TileMapLayer = room.get_node("FloorLayer")
				
				room.position.x *= tileMap.get_used_rect().size.x * 48
				room.position.y *= tileMap.get_used_rect().size.y * 48
				root.add_child(room)

	return root
		
func _generate(tries: int):
	# generate maze
	# limit maze
	# select point with most walls as spawn
	# find furthest point as boss room
	# check if we like it
	
	mazeGenerator.generate_maze()
	var center = Vector2(floor(width/2),floor(height/2))
	mazeGenerator.bfs_limit_depth(center,maxDepth)
	spawnRoomCoords = mazeGenerator.find_cell_with_most_open_walls()
	bossRoomCoords = mazeGenerator.find_furthest_point(spawnRoomCoords)
	rewardRoomCoords = mazeGenerator.get_random_dead_end()
	# try to find reward room
	var counter = 0
	while rewardRoomCoords == bossRoomCoords and counter < 10:
		counter += 1
		rewardRoomCoords = mazeGenerator.get_random_dead_end()

	var cellCount = mazeGenerator.count_non_zero_cells()
			
	
	print("attempt: ", tries)
	if tries < minTryCount:
		if cellCount < minCellCount or rewardRoomCoords.x == -1:
			if(cellCount < minCellCount): print("too little cells")
			if rewardRoomCoords.x == -1: print("failed to create rewardroom")
			return _generate(tries + 1)
	else:
		print("too many tries")
		return false
	mazeGenerator.print_maze([center,spawnRoomCoords,rewardRoomCoords,bossRoomCoords])
	return true
