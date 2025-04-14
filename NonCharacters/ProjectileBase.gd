extends CharacterBody2D
class_name ProjectileBase

@export var speed = 100
@export var lifetime = 1.0

var currLifetime: float
var dir: float
var spawnPos: Vector2
var spawnRot: float
var mask: int
var damage: float
var enabled:bool = false

func _ready():
	visible = false
	global_position = spawnPos
	global_rotation = spawnRot
	#$Area2D.set_collision_mask_value(mask, true)
	currLifetime = lifetime
	
func _physics_process(delta: float) -> void:
	if not enabled:
		return
	visible = true
	currLifetime -= delta
	if currLifetime <= 0:
		queue_free()
		return
	# direction
	velocity = Vector2(0, -speed).rotated(dir)
	# oscillate up n down
	var orth: Vector2 = velocity.rotated(PI/2).normalized()
	orth *= cos((currLifetime - lifetime) * 10) * 250
	velocity += orth
	move_and_slide()



func _on_area_2d_body_entered(body: Node2D) -> void:
	if not enabled:
		return
	if not body.has_node("HealthComponent"):
		return
		
	var healthNode: HealthComponent = body.get_node("HealthComponent")
	if healthNode != null:
		healthNode.handleDamage(damage)
	queue_free()
