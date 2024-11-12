extends StateMachine
class_name AttackComponent

signal attack_signal(state)

@export var damage := 30.0
@export var cooldown := 0.3
var cooldown_timer = 0

@onready var main = get_tree().get_root().get_node("Main2D")
@onready var projectile = load("res://projectile.tscn")
@onready var  parent:CharacterBody2D = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_state("attacking")
	add_state("idle")
	
	call_deferred("set_state","idle")

# need to be overwritten
func _state_logic(delta):
	cooldown_timer -= delta
	if(cooldown_timer <= 0):
		set_state("idle")
	
	# diagonal combination, else regular dir
	if Input.is_action_pressed("attack_left"):
		if Input.is_action_pressed("attack_up"):
			shoot(-PI/4)
		elif Input.is_action_pressed("attack_down"):
			shoot(-3*PI/4)
		else:
			shoot( -PI/2)
	elif Input.is_action_pressed("attack_right"):
		if Input.is_action_pressed("attack_up"):
			shoot(PI/4)
		elif Input.is_action_pressed("attack_down"):
			shoot(3*PI/4)
		else:
			shoot( PI/2)
			
	elif Input.is_action_pressed("attack_up"):
		shoot(0)
	elif Input.is_action_pressed("attack_down"):
		shoot(PI)
	

func shoot(dir):
	if(cooldown_timer > 0): return
	set_state("attacking")
	cooldown_timer = cooldown
	var instance = projectile.instantiate()
	instance.dir = dir
	instance.spawnPos = parent.global_position + Vector2.from_angle(dir - PI/2) * 30
	instance.spawnRot = dir
	main.add_child.call_deferred(instance)

func _get_transition(delta):
	return null

func _enter_state(new_state, old_state):
	emit_signal("attack_signal", state)
	pass
	
func _exit_state(old_state,new_state):
	pass
