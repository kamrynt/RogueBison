extends CharacterBody2D


@export var bombTimerDuration: float = 3
@export var blinkDuration: float = 0.1
var bombTimer = 0
var animationName = ""

func _ready() -> void:
	var animation = find_child("AnimatedSprite2D") as AnimatedSprite2D
	animationName = Array(animation.sprite_frames.get_animation_names()).pick_random()
	print(animationName)
	var rng = RandomNumberGenerator.new()
	blinkDuration += rng.randf_range(0,0.1)
	bombTimerDuration += rng.randf_range(0,1)

func _physics_process(delta: float) -> void:
	var animatedSprite = find_child("AnimatedSprite2D")
	if animatedSprite.frame == animatedSprite.sprite_frames.get_frame_count(animationName) - 1:
		queue_free()
		return
	
	bombTimer += delta
	
	var sprite = find_child("Sprite2D") as Sprite2D
	if int(floor(bombTimer/blinkDuration)) % 2 == 0:
		sprite.modulate = Color.WHITE
	else:
		sprite.modulate = Color.BLACK
		
	if bombTimer > bombTimerDuration:
		sprite.visible = false
		animatedSprite.play(animationName)

		
