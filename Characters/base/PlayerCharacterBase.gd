extends CharacterBody2D
extends KinematicBody2D  # Assuming this is the player base class
class_name PlayerCharacterBase

@export var healthNode: HealthComponent
@export var movementNode: UserMovementComponent
@export var attackNode: AttackComponent

var TrapScene = preload("res://traps/trap.tscn")  # Make sure trap.tscn exists

onready var globals = get_node("/root/Globals")

func _physics_process(delta):
	pass

func _process(delta):
    for position in globals.defeated_positions:
        if is_near_position(self.global_position, position):
            spawn_trap(position)
            globals.defeated_positions.erase(position)  # Remove so it doesn't repeat

# Check if player is near a previous enemy defeat location
func is_near_position(player_pos, target_pos, threshold = 50):
    return player_pos.distance_to(target_pos) < threshold

# Spawn a trap at the given position
func spawn_trap(position):
    var trap_instance = TrapScene.instance()
    trap_instance.global_position = position
    get_parent().add_child(trap_instance)