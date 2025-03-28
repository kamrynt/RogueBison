extends CharacterBody2D
class_name PlayerCharacterBase

@export var healthNode: HealthComponent
@export var movementNode: UserMovementComponent
@export var attackNode: AttackComponent
@export var weapon: ItemBase
@export var consumable: ItemBase
@export var activeSkill: ItemBase
@export var passiveSkill: ItemBase




func _physics_process(delta):
	pass
