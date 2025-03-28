extends StateMachine
class_name AttackComponent

signal attack_signal(state)

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
	
	# diagonal combination, else regular dir
	if Input.is_action_pressed("attack_left"):
		if Input.is_action_pressed("attack_up"):
			attack(-PI/4)
		elif Input.is_action_pressed("attack_down"):
			attack(-3*PI/4)
		else:
			attack( -PI/2)
	elif Input.is_action_pressed("attack_right"):
		if Input.is_action_pressed("attack_up"):
			attack(PI/4)
		elif Input.is_action_pressed("attack_down"):
			attack(3*PI/4)
		else:
			attack( PI/2)
			
	elif Input.is_action_pressed("attack_up"):
		attack(0)
	elif Input.is_action_pressed("attack_down"):
		attack(PI)
	
func attack(direction):
	var weapon:ItemBase = parent.weapon
	if weapon != null:
		if weapon.weaponType == weapon.WeaponTypes.Ranged:
			shoot(direction)
		

func shoot(direction):
	if(cooldown_timer > 0): return
	var weapon:ItemBase = parent.weapon
	set_state("attacking")
	var projectile = load(weapon.projectilePath)
	var projectileInstance = projectile.instantiate()
	cooldown_timer = weapon.cooldown
	projectileInstance.damage = weapon.damage
	
	projectileInstance.enabled = true
	projectileInstance.dir = direction
	#projectileInstance.mask = 2
	projectileInstance.spawnPos = parent.global_position + Vector2.from_angle(direction - PI/2) * 30
	projectileInstance.spawnRot = direction
	main.add_child.call_deferred(projectileInstance)

func _get_transition(delta):
	return null

func _enter_state(new_state, old_state):
	emit_signal("attack_signal", state)
	pass
	
func _exit_state(old_state,new_state):
	pass
