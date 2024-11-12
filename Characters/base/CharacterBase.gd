extends CharacterBody2D
class_name BaseCharacter

@export var healthNode: HealthComponent
@export var movementNode: MovementComponent
@export var attackNode: AttackComponent

func _physics_process(delta):
	for child in get_children():
		if child is StateMachine:
			print("123")
