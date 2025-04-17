extends "res://Characters/enemies/enemy.gd"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var crow_projectile_scene := preload("res://NonCharacters/CrowProjectile.tscn")

func _ready() -> void:
	# Override the default projectile with the crow-specific one
	projectile_scene = crow_projectile_scene
	super._ready()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	update_animation()

func update_animation() -> void:
	if velocity.length() < 10:
		animated_sprite.play("idle")
	elif velocity.y < 0:
		animated_sprite.play("flapping")
	else:
		if velocity.x < 0:
			animated_sprite.play("gliding_left")
		else:
			animated_sprite.play("gliding_right")
