extends CharacterBody2D

@export var SPEED = 100
@export var LIFETIME = 1.0

var currLifetime: float
var dir: float
var spawnPos: Vector2
var spawnRot: float

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
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
