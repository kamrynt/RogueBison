extends CharacterBody2D

@export var player: NodePath  # Assign the Player node manually
@export var follow_distance: float = 80.0
@export var speed: float = 100.0
@export var attack_range: float = 150.0  # The range in which bison detects enemies
@export var attack_contact_range: float = 30.0  # Must be very close to attack
@export var attack_cooldown: float = 1.5  # Time between attacks
@export var horn_damage: float = 50.0
@export var kick_damage: float = 70.0

@onready var sprite = $BisonSprite  # Reference to AnimatedSprite2D
@onready var attack_timer = $Timer  # Ensure this node exists in the scene!

var player_node: CharacterBody2D
var target_enemy: CharacterBody2D = null
var attacking: bool = false

func _ready():
	if player:
		player_node = get_node(player)
	
	if attack_timer:
		attack_timer.wait_time = attack_cooldown
		attack_timer.one_shot = true

func _process(delta):
	if attacking: 
		return  # If attacking, don't change behavior
	
	if player_node:
		var enemies = get_nearby_enemies()

		if enemies.size() > 0:
			target_enemy = enemies[0]  # Pick the closest enemy
			move_towards_enemy(delta)
		else:
			target_enemy = null
			follow_player(delta)  # Resume following the player

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

	enemies.sort_custom(func(a, b): return a["distance"] < b["distance"])
	return enemies.map(func(e): return e["node"])

func move_towards_enemy(delta):
	if target_enemy and target_enemy.is_inside_tree():
		var direction = (target_enemy.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		update_animation(direction)

		# Ensure the bison gets CLOSE before attacking
		if global_position.distance_to(target_enemy.global_position) < attack_contact_range and not attacking:
			perform_attack(target_enemy)

func perform_attack(enemy):
	if enemy and enemy.is_inside_tree():
		attacking = true  
		velocity = Vector2.ZERO  # Stop moving before attacking

		var attack_type = randi() % 2  # Randomly choose attack

		if attack_type == 0:  # Horn attack (Face enemy)
			face_enemy(enemy, true)
			sprite.play("horn_attack")  
			enemy.healthNode.handleDamage(horn_damage)  
		else:  # Back kick (Face away from enemy)
			face_enemy(enemy, false)
			sprite.play("back_kick")  
			enemy.healthNode.handleDamage(kick_damage)  

		await get_tree().create_timer(0.5).timeout  
		
		if attack_timer:
			attack_timer.start()  # Start cooldown timer
		
		attacking = false  

func face_enemy(enemy, face_forward: bool):
	var direction = enemy.global_position - global_position
	
	if face_forward:
		sprite.flip_h = direction.x < 0  # Face the enemy for horn attack
	else:
		sprite.flip_h = direction.x > 0  # Face away for back kick

func update_animation(direction):
	if attacking: 
		return  # Don't change animation while attacking
	
	if direction.length() == 0:
		sprite.play("idle")
	elif sprite.animation not in ["horn_attack", "back_kick"]:
		sprite.play("walk_left")

	sprite.flip_h = direction.x > 0  
