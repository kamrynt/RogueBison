extends StateMachine
class_name HealthComponent

signal health_signal(state)
@export var MAX_HEALTH: float = 300.0
var health: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = MAX_HEALTH
	add_state("damaged")
	add_state("healed")
	add_state("stunned")
	add_state("dead")
	add_state("idle")
	set_state("idle")

# need to be overwritten
func _state_logic(delta):
	pass
	
func handleDamage(damage):
	if state == "dead": return
	
	set_state("damaged")
	health -= damage
	if health <= 0:
		set_state("dead")
	
func _get_transition(delta):
	return null

func _enter_state(new_state, old_state):
	emit_signal("health_signal", state)
	pass
	
func _exit_state(old_state,new_state):
	pass
