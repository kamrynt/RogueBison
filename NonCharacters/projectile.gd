extends Area2D

@export var speed := 300.0
@export var direction: Vector2 = Vector2.ZERO
@export var damage := 10.0
@export var shooter_type := "enemy"  # or "player"

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))  # ✅ connect signal
	await get_tree().create_timer(5).timeout
	queue_free()

func _physics_process(delta: float) -> void:
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
