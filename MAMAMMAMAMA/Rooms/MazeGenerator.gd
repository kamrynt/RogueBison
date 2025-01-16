extends Resource
class_name MazeGenerator
# https://weblog.jamisbuck.org/2011/1/24/maze-generation-hunt-and-kill-algorithm

@export var width: int = 5
@export var height: int = 5
const N = Globals.N
const S = Globals.S
const E = Globals.E
const W = Globals.W
const IN = Globals.IN
const DX = Globals.DX
const DY = Globals.DY
const OPPOSITE = Globals.OPPOSITE

# Grid to store the maze
var grid: Array = []

func _init():
	pass

func cell_to_directions(cell_value: int) -> Dictionary:
	return {
		"N": (cell_value & N) != 0,
		"E": (cell_value & E) != 0,
		"S": (cell_value & S) != 0,
		"W": (cell_value & W) != 0 }

func _initialize_grid():
	grid.clear()
	for y in range(height):
		var row: Array[int] = []
		for x in range(width):
			row.append(0)
		grid.append(row)

func generate_maze():
	var x = randi() % width
	var y = randi() % height
	_initialize_grid()
	while true:
		var result = _walk(x, y)
		if result.size() == 2:
			x = result[0]
			y = result[1]
		else:
			result = _hunt()
			if result.size() == 2:
				x = result[0]
				y = result[1]
			else:
				break
	return grid

func _walk(x: int, y: int) -> Array[int]:
	var directions = [N, S, E, W]
	directions.shuffle()
	for dir in directions:
		var nx = x + DX[dir]
		var ny = y + DY[dir]
		if nx >= 0 and ny >= 0 and ny < len(grid) and nx < len(grid[ny]) and grid[ny][nx] == 0:
			grid[y][x] |= dir
			grid[ny][nx] |= OPPOSITE[dir]
			return [nx, ny]
	return []

func _hunt() -> Array[int]:
	for y in range(height):
		for x in range(width):
			if grid[y][x] != 0:
				continue
			var neighbors = []
			if y > 0 and grid[y - 1][x] != 0:
				neighbors.append(N)
			if x > 0 and grid[y][x - 1] != 0:
				neighbors.append(W)
			if x + 1 < width and grid[y][x + 1] != 0:
				neighbors.append(E)
			if y + 1 < height and grid[y + 1][x] != 0:
				neighbors.append(S)

			if neighbors.size() > 0:
				var direction = neighbors[randi() % neighbors.size()]
				var nx = x + DX[direction]
				var ny = y + DY[direction]

				if nx >= 0 and ny >= 0 and nx < width and ny < height:
					grid[y][x] |= direction
					grid[ny][nx] |= OPPOSITE[direction]
					return [x, y]

	return []

# Helper function to perform BFS up to a specified depth
func bfs_limit_depth(start: Vector2, max_depth: int):
	var start_x = int(start.x)
	var start_y = int(start.y)
	
	# Initialize a queue for BFS with the starting point and depth 0
	var queue = [[start_x, start_y, 0]]
	
	# Dictionary to keep track of visited nodes
	var visited = {}
	
	while queue.size() > 0:
		var current = queue.pop_front()
		var x = current[0]
		var y = current[1]
		var depth = current[2]
		
		# Create a string key for the current coordinates
		var coord_key = str(x) + "," + str(y)
		
		# Skip if already visited
		if visited.has(coord_key):
			continue
		
		# Mark as visited
		visited[coord_key] = true
		
		# If depth equals or exceeds max_depth, do not add neighbors
		if depth >= max_depth:
			continue
		
		# Explore neighbors through valid passages
		var cell_value = grid[y][x]
		for dir in [N, S, E, W]:
			if (cell_value & dir) != 0:
				var nx = x + DX[dir]
				var ny = y + DY[dir]
				
				# Ensure the new coordinates are within bounds
				if nx >= 0 and ny >= 0 and nx < width and ny < height:
					var neighbor_key = str(nx) + "," + str(ny)
					if not visited.has(neighbor_key):
						queue.append([nx, ny, depth + 1])
	
	# Reset cells beyond max_depth and update neighbors
	for y in range(height):
		for x in range(width):
			var cell_key = str(x) + "," + str(y)
			if not visited.has(cell_key):
				# Reset the current cell
				grid[y][x] = 0  # Set to 0 indicating no passages
				
				# Update neighboring cells to remove passages to this cell
				for dir in [N, S, E, W]:
					var nx = x + DX[dir]
					var ny = y + DY[dir]
					if nx >= 0 and ny >= 0 and nx < width and ny < height:
						# Remove the opposite direction passage in the neighbor
						grid[ny][nx] &= ~OPPOSITE[dir]


func find_furthest_point(start: Vector2) -> Vector2:
	var start_x = int(start.x)
	var start_y = int(start.y)
	
	# Initialize a queue for BFS with the starting point and distance 0
	var queue = [[start_x, start_y, 0]]
	
	# Dictionary to keep track of visited nodes
	var visited = {}
	
	# Variables to track the furthest point and maximum distance
	var furthest_point = Vector2(start_x, start_y)
	var max_distance = 0
	
	while queue.size() > 0:
		var current = queue.pop_front()
		var x = current[0]
		var y = current[1]
		var distance = current[2]
		
		# Create a string key for the current coordinates
		var coord_key = str(x) + "," + str(y)
		
		# Skip if already visited
		if visited.has(coord_key):
			continue
		
		# Mark as visited
		visited[coord_key] = true
		
		# Update furthest point if this node is farther
		if distance > max_distance:
			max_distance = distance
			furthest_point = Vector2(x, y)
		
		# Explore neighbors through valid passages
		var cell_value = grid[y][x]
		for dir in [N, S, E, W]:
			if (cell_value & dir) != 0:
				var nx = x + DX[dir]
				var ny = y + DY[dir]
				# Ensure the new coordinates are within bounds
				if nx >= 0 and ny >= 0 and nx < width and ny < height:
					var neighbor_key = str(nx) + "," + str(ny)
					# Check if the neighboring cell has the corresponding passage
					var neighbor_value = grid[ny][nx]
					if (neighbor_value & OPPOSITE[dir]) != 0 and not visited.has(neighbor_key):
						queue.append([nx, ny, distance + 1])
	
	return furthest_point


func get_random_dead_end() -> Vector2:
	var dead_ends = []

	for y in range(height):
		for x in range(width):
			var cell_value = grid[y][x]
			# Count the number of passages (bits set to 1)
			var passage_count = 0
			for direction in [N, S, E, W]:
				if cell_value & direction != 0:
					passage_count += 1
			# If there's only one passage, it's a dead-end
			if passage_count == 1:
				dead_ends.append(Vector2(x, y))

	if dead_ends.size() > 0:
		var random_index = randi() % dead_ends.size()
		return dead_ends[random_index]
	else:
		return Vector2(-1, -1)  # Indicates no dead-ends found


func print_maze(marked_positions: Array = []):
	# Define characters for walls and passages
	var horizontal_wall = "─"
	var vertical_wall = "│"
	var corner = "┼"
	var space = " "

	# Create a dictionary to map marked positions to their indices
	var marked_dict = {}
	for i in range(marked_positions.size()):
		var pos = marked_positions[i]
		marked_dict[str(pos.x) + "," + str(pos.y)] = str(i)

	# Iterate through each row in the grid
	for y in range(height):
		var top_line = ""
		var mid_line = ""
		for x in range(width):
			var cell = grid[y][x]

			# Determine the presence of walls based on cell value
			var north_wall = (cell & N) == 0
			var west_wall = (cell & W) == 0

			# Top line (north walls)
			if north_wall:
				top_line += corner + horizontal_wall
			else:
				top_line += corner + space

			# Middle line (west walls and cell space)
			if west_wall:
				mid_line += vertical_wall
			else:
				mid_line += space

			# Check if the current position is marked
			var coord_key = str(x) + "," + str(y)
			if marked_dict.has(coord_key):
				mid_line += marked_dict[coord_key]
			else:
				mid_line += space

		# Close the rightmost edge
		top_line += corner
		mid_line += vertical_wall

		# Print the constructed lines
		print(top_line)
		print(mid_line)

	# Print the bottom boundary
	var bottom_line = ""
	for x in range(width):
		bottom_line += corner + horizontal_wall
	bottom_line += corner
	print(bottom_line)
	print("")


	
func find_cell_with_most_open_walls() -> Vector2:
	var max_open_walls = -1
	var candidates = []

	for y in range(height):
		for x in range(width):
			var cell_value = grid[y][x]
			var open_walls = 0

			# Check each direction for an open wall
			if (cell_value & N) != 0:
				open_walls += 1
			if (cell_value & S) != 0:
				open_walls += 1
			if (cell_value & E) != 0:
				open_walls += 1
			if (cell_value & W) != 0:
				open_walls += 1

			# Update candidates list based on the number of open walls
			if open_walls > max_open_walls:
				max_open_walls = open_walls
				candidates = [Vector2(x, y)]
			elif open_walls == max_open_walls:
				candidates.append(Vector2(x, y))

	# Randomly select one of the candidates if multiple exist
	if candidates.size() > 0:
		var random_index = randi() % candidates.size()
		return candidates[random_index]
	else:
		return Vector2(-1, -1)  # Indicates no valid cell found

func count_non_zero_cells() -> int:
	var count = 0
	for row in grid:
		for cell in row:
			if cell != 0:
				count += 1
	return count
