extends CharacterBody2D
class_name NPCCharacterBase

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var healthNode: HealthComponent = null
@export var movementNode: NPCMovementComponent = null
@export var attackNode: NPCAttackComponent = null

func set_target(target: CharacterBody2D):
	if movementNode != null:
		movementNode.target = target
	if attackNode != null:
		attackNode.target = target
	pass
		
func _physics_process(delta: float) -> void:
	if healthNode.state == "dead":
		queue_free()
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
	pass
