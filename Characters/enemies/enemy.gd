extends CharacterBody2D

@export var speed := 50.0
@export var chase_speed := 200.0
@export var vision_range := 200.0
@export var attack_cooldown := 1.5
@export var projectile_speed := 400.0

#var velocity: Vector2 = Vector2.ZERO
var player: Node2D
var can_attack := true

@onready var projectile_scene := preload("res://NonCharacters/projectile.tscn")
@onready var attack_timer := Timer.new()

func _ready() -> void:
	randomize()
	set_random_direction()
	player = get_tree().get_root().get_node("Main2D/Character")  # Update this path if needed
	add_to_group("enemies")

	# Setup the attack cooldown timer
	attack_timer.wait_time = attack_cooldown
	attack_timer.one_shot = true
	attack_timer.timeout.connect(Callable(self, "_on_attack_timer_timeout"))
	add_child(attack_timer)

func _physics_process(delta: float) -> void:
	if player and is_instance_valid(player):
		var distance = global_position.distance_to(player.global_position)

		if distance <= vision_range:
			# ✅ Chase the player
			var direction_to_player = (player.global_position - global_position).normalized()
			velocity = direction_to_player * chase_speed

			# ✅ Only shoot if chasing and not on cooldown
			if can_attack and velocity.length() > 0.1:
				shoot_projectile(direction_to_player)
		else:
			# ✅ Wander if player is not in range
			velocity = velocity.normalized() * speed

		# ✅ Move and bounce if hit wall
		var collision = move_and_collide(velocity * delta)
		if collision and distance > vision_range:
			set_random_direction()

func set_random_direction() -> void:
	var angle = randf_range(0, TAU)
	velocity = Vector2(cos(angle), sin(angle)).normalized()

func shoot_projectile(direction: Vector2) -> void:
	can_attack = false
	attack_timer.start()

	var bullet = projectile_scene.instantiate()
	bullet.global_position = global_position
	bullet.direction = direction
	bullet.speed = projectile_speed
	bullet.shooter_type = "enemy"
	get_parent().add_child(bullet)

func _on_attack_timer_timeout() -> void:
	can_attack = true
	
func apply_damage(amount: float) -> void:
	queue_free()
