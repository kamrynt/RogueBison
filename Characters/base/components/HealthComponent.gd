extends StateMachine
class_name HealthComponent

signal health_signal(state)
@export var MAX_HEALTH: float = 300.0
var health: float

onready var globals = get_node("/root/Globals")  # Access global script

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = MAX_HEALTH
	add_state("damaged")
	add_state("healed")
	add_state("stunned")
	add_state("dead")
	add_state("idle")
	set_state("idle")

# Function that handles taking damage
func handleDamage(damage):
	if state == "dead": 
		return  # Prevent further damage if already dead
	
	set_state("damaged")
	health -= damage
	
	if health <= 0:
		track_defeat_location()  # Store the enemy’s position before setting to "dead"
		set_state("dead")

# Store the position of the defeated enemy
func track_defeat_location():
	if owner:  # Ensure this component is attached to an enemy
		globals.defeated_positions.append(owner.global_position)  # Save position
		owner.queue_free()  # Remove the enemy from the scene

func _get_transition(delta):
	return null

func _enter_state(new_state, old_state):
	emit_signal("health_signal", state)
	pass

func _exit_state(old_state, new_state):
	pass
