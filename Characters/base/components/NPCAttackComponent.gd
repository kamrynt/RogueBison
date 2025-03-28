extends StateMachine
class_name NPCAttackComponent

@export var target: PlayerCharacterBase = null

@export var damage := 30.0
@export var cooldown := 0.3
@export var isProjectile: bool = false
var cooldown_timer = 0

@onready var main = get_tree().get_root().get_node("Main2D")
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
	
	if isProjectile && target != null:
		var toTargetDir: Vector2 = (target.global_position - parent.global_position).normalized()
		shoot(toTargetDir.angle() + PI/2)
	

func shoot(dir):
	pass
	#if(cooldown_timer > 0): return
	#set_state("attacking")
	#cooldown_timer = cooldown
	#var instance = projectile.instantiate()
	#instance.dir = dir
	#instance.mask = 1
	#instance.damage = damage	
	#instance.spawnPos = parent.global_position + Vector2.from_angle(dir - PI/2) * 30
	#instance.spawnRot = dir
	#main.add_child.call_deferred(instance)

func _get_transition(delta):
	return null

func _enter_state(new_state, old_state):
	#emit_signal("attack_signal", state)
	pass
	
func _exit_state(old_state,new_state):
	pass
