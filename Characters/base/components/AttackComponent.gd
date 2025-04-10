extends StateMachine
class_name AttackComponent

signal attack_signal(state)

@export var damage := 30.0
@export var cooldown := 0.3

var cooldown_timer := 0.0

@onready var main := get_tree().get_root().get_node("Main2D")
@onready var projectile_scene := preload("res://NonCharacters/projectile.tscn")
#@onready var projectile_scene := preload("res://NonCharacters/Items/tempweapon/tempprojectile.tscn")
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



func shoot(dir: float) -> void:
	if cooldown_timer > 0:
		return

	set_state("attacking")
	cooldown_timer = cooldown

	var bullet = projectile_scene.instantiate()

	var direction_vector = Vector2.from_angle(dir).normalized()
	bullet.global_position = parent.global_position + direction_vector * 16  # closer to player
	bullet.direction = direction_vector
	bullet.speed = 450.0
	bullet.damage = damage
	bullet.shooter_type = "player"

	main.add_child.call_deferred(bullet)


func _get_transition(delta: float):
	return null

func _enter_state(new_state, old_state):
	emit_signal("attack_signal", state)

func _exit_state(old_state, new_state):
	pass
