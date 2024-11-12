extends CharacterBody2D

@export var SPEED = 100
@export var LIFETIME = 1.0

var currLifetime: float
var dir: float
var spawnPos: Vector2
var spawnRot: float
var mask: int
var damage: float

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	$Area2D.set_collision_mask_value(mask, true)
	currLifetime = LIFETIME
	
func _physics_process(delta: float) -> void:
	currLifetime -= delta
	if currLifetime <= 0:
		queue_free()
		return
	# direction
	velocity = Vector2(0, -SPEED).rotated(dir)
	# oscillate up n down
	var orth: Vector2 = velocity.rotated(PI/2).normalized()
	orth *= cos((currLifetime - LIFETIME) * 10) * 250
	velocity += orth
	move_and_slide()



func _on_area_2d_body_entered(body: Node2D) -> void:
	var healthNode: HealthComponent = body.get_node("HealthComponent")
	if healthNode != null:
		healthNode.handleDamage(damage)
	queue_free()
