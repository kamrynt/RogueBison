extends StateMachine
class_name NPCMovementComponent

enum MovementStyles {Hover, Chase, Bounce, Wander}
@export var MovementStyle: MovementStyles = 1
@export var Speed: float = 100.0
@export var Flying: bool = false
@export var target: CharacterBody2D

@onready var parent: NPCCharacterBase = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_state("moving")
	add_state("idle")
	set_state("idle")

func chase(delta):
	if target == null: return
	var toTargetVec: Vector2 = (target.global_position - parent.global_position)
	# too close
	if(toTargetVec.length() < 0.05):
		set_state("idle")
		return
		
	set_state("moving")
	parent.velocity = toTargetVec.normalized() * Speed
	parent.move_and_slide()

# need to be overwritten
func _state_logic(delta):
	match MovementStyle:
		MovementStyles.Chase:
			chase(delta)
	
func _get_transition(delta):
	return null

func _enter_state(new_state, old_state):
	pass
	
func _exit_state(old_state,new_state):
	pass
