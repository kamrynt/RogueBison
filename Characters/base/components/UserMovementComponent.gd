extends StateMachine
class_name UserMovementComponent

@export var ACCELERATION: float = 2000.0
@export var MAX_VELOCITY: float = 300.0
@export var FRICTION: float = 2000.0

@onready var parent: CharacterBody2D = get_parent()
@onready var velocity: Vector2 = parent.velocity
@onready var sprite: AnimatedSprite2D = parent.get_node("AnimatedSprite2D")  # Get the sprite for animation

signal movement_signal(state)

func _ready() -> void:
	add_state("running")
	add_state("idle")
	set_state("idle")

func _state_logic(delta):
	movement(delta)

func movement(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	input_vector = input_vector.normalized()
	var velocity: Vector2 = parent.velocity

	if input_vector.length() > 0.01:
		set_state("running")
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.limit_length(MAX_VELOCITY)

		update_animation(input_vector)  # Update animation when moving
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		if velocity.length() <= 0.001:
			set_state("idle")
			update_animation(Vector2.ZERO)  # Switch to idle when stopping

	parent.velocity = velocity
	parent.move_and_slide()

func _get_transition(delta):
	return null

func _enter_state(new_state, old_state):
	emit_signal("movement_signal", state)

func _exit_state(old_state, new_state):
	pass

# **✅ Animation Handling Function**
func update_animation(direction: Vector2):
	if direction.length() == 0:  # If not moving, play idle animation
		if sprite.animation != "idle":
			sprite.play("idle")
		return

	if sprite.animation != "walk_right":  # Play only if not already playing
		sprite.play("walk_right")

	sprite.flip_h = direction.x < 0  # Flip when moving left
