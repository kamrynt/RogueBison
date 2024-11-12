extends StateMachine
class_name UserMovementComponent

@export var ACCELERATION: float = 2000.0
@export var MAX_VELOCITY: float = 300.0
@export var FRICTION: float = 2000.0

@onready var  parent:CharacterBody2D = get_parent()
@onready var velocity: Vector2 = parent.velocity

signal movement_signal(state)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_state("running")
	add_state("idle")
	set_state("idle")

# need to be overwritten

func _state_logic(delta):
#	if any movement is pressed
	movement(delta)


func movement(delta):
	if state == "running" || Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_down") || Input.is_action_pressed("ui_up"):
		set_state("running")
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_vector = Vector2.ZERO
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

		input_vector = input_vector.normalized()
		var velocity: Vector2 = parent.velocity
		if input_vector.length() > 0.01:
			velocity += input_vector * ACCELERATION * delta
			var clampedVelocity = clamp(velocity.length(), 0,MAX_VELOCITY)
			velocity = velocity.normalized()
			velocity *= clampedVelocity
			
		else:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		parent.velocity = velocity	
		parent.move_and_slide()
	if(parent.velocity.length() <= 0.001):
		set_state("idle")
		
func _get_transition(delta):
	return null

func _enter_state(new_state, old_state):
	emit_signal("movement_signal", state)
	pass
	
func _exit_state(old_state,new_state):
	pass
