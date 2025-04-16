extends CharacterBody2D

@export var speed := 50.0
@export var chase_speed := 200.0
@export var vision_range := 200.0
@export var attack_range := 40.0
@export var attack_cooldown := 1.5
@export var attack_damage := 20.0

var player: Node2D
var can_attack := true
var is_attacking := false

@onready var attack_timer := Timer.new()
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	randomize()
	set_random_direction()
	player = get_tree().get_root().get_node("Main2D/Character")
	add_to_group("enemies")

	attack_timer.wait_time = attack_cooldown
	attack_timer.one_shot = true
	attack_timer.timeout.connect(Callable(self, "_on_attack_timer_timeout"))
	add_child(attack_timer)

func _physics_process(delta: float) -> void:
	if player and is_instance_valid(player):
		var distance = global_position.distance_to(player.global_position)
		var direction_to_player = (player.global_position - global_position).normalized()

		if distance <= vision_range:
			velocity = direction_to_player * chase_speed

			if distance <= attack_range and can_attack:
				perform_attack()
			else:
				# Only play run if not attacking
				if not is_attacking:
					play_run_animation()
		else:
			velocity = velocity.normalized() * speed
			play_walk_animation()

		var collision = move_and_collide(velocity * delta)
		if collision and distance > vision_range:
			set_random_direction()

func set_random_direction() -> void:
	var angle = randf_range(0, TAU)
	velocity = Vector2(cos(angle), sin(angle)).normalized()

func perform_attack() -> void:
	can_attack = false
	is_attacking = true
	attack_timer.start()
	play_attack_animation()

	# Optional delay based on animation frame could go here
	if "apply_damage" in player:
		player.apply_damage(attack_damage)

func _on_attack_timer_timeout() -> void:
	can_attack = true
	is_attacking = false

func apply_damage(amount: float) -> void:
	queue_free()

func play_walk_animation() -> void:
	if sprite.animation != "walk" or !sprite.is_playing():
		sprite.play("walk")

func play_run_animation() -> void:
	if sprite.animation != "run" or !sprite.is_playing():
		sprite.play("run")

func play_attack_animation() -> void:
	sprite.play("attack")
