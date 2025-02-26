extends CharacterBody2D


@export var player: NodePath  # Assign the Player node manually
@export var follow_distance: float = 80.0
@export var speed: float = 100.0
@onready var sprite = $BisonSprite  # Reference to AnimatedSprite2D

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
	var direction = (player_pos - global_position).normalized()

	if distance > follow_distance:  # Move if too far
		velocity = direction * speed
		move_and_slide()
		update_animation(direction)  # Update animation when moving
	else:
		velocity = Vector2.ZERO
		update_animation(Vector2.ZERO)  # Play idle when stopped


func update_animation(direction):
	if direction.length() == 0:  # If not moving, play idle animation
		if sprite.animation != "idle":
			sprite.play("idle")  # Only play if not already playing
		return

	if sprite.animation != "walk_left":  # Play only if not already playing
		sprite.play("walk_left")

	sprite.flip_h = direction.x > 0  # Flip when moving right
