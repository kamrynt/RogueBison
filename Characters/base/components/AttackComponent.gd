extends StateMachine
class_name AttackComponent

signal attack_signal(state)

@export var damage := 30.0
@export var cooldown := 0.3

var cooldown_timer := 0.0

@onready var main := get_tree().get_root().get_node("Main2D")
#@onready var projectile_scene := preload("res://NonCharacters/projectile.tscn")
#@onready var projectile_scene := preload("res://NonCharacters/ProjectileBase.tscn")
@onready var parent: CharacterBody2D = get_parent()

func _ready() -> void:
	add_state("attacking")
	add_state("idle")
	call_deferred("set_state", "idle")

func _state_logic(delta: float) -> void:
	cooldown_timer -= delta
	if cooldown_timer <= 0:
		set_state("idle")

	# Godot 4 angles + flipped Y fix
	if Input.is_action_pressed("attack_left"):
		if Input.is_action_pressed("attack_up"):
			shoot(-3 * PI / 4)     # up-left
		elif Input.is_action_pressed("attack_down"):
			shoot(3 * PI / 4)      # down-left
		else:
			shoot(PI)              # left

	elif Input.is_action_pressed("attack_right"):
		if Input.is_action_pressed("attack_up"):
			shoot(-PI / 4)         # up-right
		elif Input.is_action_pressed("attack_down"):
			shoot(PI / 4)          # down-right
		else:
			shoot(0)               # right

	elif Input.is_action_pressed("attack_up"):
		shoot(-PI / 2)             # up

	elif Input.is_action_pressed("attack_down"):
		shoot(PI / 2)              # down



func shoot(direction):
	if cooldown_timer > 0:
		return

	var weapon: ItemBase = parent.weapon
	if weapon == null:
		return

	set_state("attacking")
	var projectile = load(weapon.projectilePath)
	var projectileInstance = projectile.instantiate()

	cooldown_timer = weapon.cooldown
	projectileInstance.damage = weapon.damage
	projectileInstance.enabled = true
	projectileInstance.dir = direction
	projectileInstance.spawnPos = parent.global_position + Vector2.from_angle(direction - PI/2) * 30
	projectileInstance.spawnRot = direction

	main.add_child.call_deferred(projectileInstance)


	
	
func _get_transition(delta: float):
	return null

func _enter_state(new_state, old_state):
	#emit_signal("attack_signal", state)
	pass

func _exit_state(old_state, new_state):
	pass
