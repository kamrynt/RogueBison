extends CharacterBody2D
class_name PlayerCharacterBase

const FRICTION: float = 0.15


@export var healthNode: HealthComponent
@export var movementNode: UserMovementComponent
@export var attackNode: AttackComponent

func _physics_process(delta):
	pass
