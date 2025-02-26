extends CharacterBody2D

@export var player: NodePath  # Assign the Player node manually
@export var follow_distance: float = 80.0
@export var speed: float = 100.0

var player_node: CharacterBody2D  # Stores actual reference to the player

func _ready():
	if player:
		player_node = get_node(player)  # Fetch the assigned node

func _process(delta):
	if player_node:
		follow_player(delta)

func follow_player(delta):
	var player_pos = player_node.global_position
	var distance = global_position.distance_to(player_pos)
	
	if distance > follow_distance:
		var direction = (player_pos - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
