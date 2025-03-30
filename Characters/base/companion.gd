extends CharacterBody2D

@export var player: NodePath
@export var follow_distance: float = 80.0
@export var speed: float = 100.0
@export var attack_range: float = 150.0
@export var attack_contact_range: float = 30.0
@export var attack_cooldown: float = 1.5
@export var horn_damage: float = 50.0
@export var kick_damage: float = 70.0

@onready var sprite = $BisonSprite
@onready var attack_timer: Timer = $Timer

var player_node: CharacterBody2D
var target_enemy: CharacterBody2D = null
var attacking := false

func _ready():
	if player:
		player_node = get_node(player)

	attack_timer.wait_time = attack_cooldown
	attack_timer.one_shot = true
	attack_timer.timeout.connect(Callable(self, "_on_attack_timer_timeout"))

func _process(delta):
	if attacking:
		return

	if player_node:
		var enemies = get_nearby_enemies()

		if enemies.size() > 0:
			target_enemy = enemies[0]

			# ⚠ Temporarily disable follow distance while attacking
			move_towards_enemy(delta)
		else:
			target_enemy = null
			follow_player(delta)  # Only follow when no enemy is close


func follow_player(delta):
	var player_pos = player_node.global_position
	var distance = global_position.distance_to(player_pos)
	var direction = (player_pos - global_position).normalized()

	if distance > follow_distance:
		velocity = direction * speed
		move_and_slide()
		update_animation(direction)
	else:
		velocity = Vector2.ZERO
		update_animation(Vector2.ZERO)

func get_nearby_enemies():
	var enemies = []
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy and enemy.is_inside_tree():
			var distance_to_player = enemy.global_position.distance_to(player_node.global_position)
			if distance_to_player <= attack_range:
				enemies.append({"node": enemy, "distance": distance_to_player})

	# Prioritize closest to player
	enemies.sort_custom(func(a, b): return a["distance"] < b["distance"])
	return enemies.map(func(e): return e["node"])


func move_towards_enemy(delta):
	if target_enemy and target_enemy.is_inside_tree():
		var direction = (target_enemy.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		update_animation(direction)

		if global_position.distance_to(target_enemy.global_position) < attack_contact_range and not attacking:
			perform_attack(target_enemy)

func perform_attack(enemy):
	if enemy and enemy.is_inside_tree():
		attacking = true
		velocity = Vector2.ZERO

		var attack_type = randi() % 2  # 0 = horn, 1 = kick

		if attack_type == 0:
			face_enemy(enemy, true)
			sprite.play("horn_attack")
			if enemy.has_method("apply_damage"):
				enemy.apply_damage(horn_damage)
		else:
			face_enemy(enemy, false)
			sprite.play("back_kick")
			if enemy.has_method("apply_damage"):
				enemy.apply_damage(kick_damage)

		attack_timer.start()

func _on_attack_timer_timeout():
	attacking = false

func face_enemy(enemy, face_forward: bool):
	var direction = enemy.global_position - global_position

	if face_forward:
		sprite.flip_h = direction.x < 0
	else:
		sprite.flip_h = direction.x > 0

func update_animation(direction: Vector2):
	if attacking:
		return

	if direction.length() == 0:
		sprite.play("idle")
	elif sprite.animation not in ["horn_attack", "back_kick"]:
		sprite.play("walk_left")

	sprite.flip_h = direction.x > 0
