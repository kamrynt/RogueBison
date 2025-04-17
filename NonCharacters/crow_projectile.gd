extends Area2D

@export var speed: float = 300.0
@export var direction: Vector2 = Vector2.ZERO
@export var damage: float = 10.0
@export var shooter_type: String = "enemy"  # "enemy" or "player"

func _ready() -> void:
	if direction == Vector2.ZERO:
		print("❌ Crow feather launched with ZERO direction!")
	else:
		print("🪶 Crow feather launched with direction: ", direction)

	# Connect body entered signal
	connect("body_entered", Callable(self, "_on_body_entered"))

	# Auto-delete after 5 seconds
	await get_tree().create_timer(5).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	# Move in the given direction
	position += direction.normalized() * speed * delta

func _on_body_entered(body: Node) -> void:
	if shooter_type == "enemy" and body.is_in_group("player"):
		if body.has_method("apply_damage"):
			body.apply_damage(damage)
		queue_free()

	elif shooter_type == "player" and body.is_in_group("enemies"):
		if body.has_method("apply_damage"):
			body.apply_damage(damage)
		queue_free()
