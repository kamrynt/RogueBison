extends StateMachine
class_name NPCMovementComponent

enum MovementStyles {Hover, Chase, Bounce, Wander}

@export var MovementStyle: MovementStyles = 1
@export var Speed: float = 100.0
@export var Flying: bool = false
@export var target: CharacterBody2D

@export var idleDur: float = 3
@export var wanderDur: float = 3
@export var hoverDistance: float = 500
@export var shootPerAttack: int = 3
var wanderTimer = 0
var idleTimer = 0
var moveDir = Vector2(0,0)
var shootCounter = 0
@onready var main = get_tree().get_root().get_node("Main2D")
@onready var parent: NPCCharacterBase = get_parent()
@onready var sprite: AnimatedSprite2D = parent.get_node("AnimatedSprite2D")  # Get the sprite for animation


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_state("moving")
	add_state("idle")
	add_state("dead")
	add_state("attacking")
	call_deferred("set_state","idle")
	target = main.get_node("%Character")

func chase(delta):
	if target == null: return
	var toTargetVec: Vector2 = (target.global_position - parent.global_position)
	# too close
	if(toTargetVec.length() < 0.05):
		set_state("idle")
		return
		
	set_state("moving")
	parent.velocity = toTargetVec.normalized() * Speed
	parent.move_and_slide()

var prevFrame = -1
func hover(delta):
	if target == null: return
	
	var toTargetVec: Vector2 = (target.global_position - parent.global_position)
	
	if parent.healthNode.state == "dead":
		set_state("dead")
	
	match state:
		"dead":
			sprite.play("death")
			pass
		"moving":
			wanderTimer -= delta
			
			if(wanderTimer < 0):
				print('finished moving, now attacking')
				wanderTimer = wanderDur
				set_state("attacking")
				return
			
			parent.velocity = moveDir.normalized() * Speed
			parent.move_and_slide()
			
			sprite.play("walk")
			sprite.flip_h = moveDir.x < 0  # Flip when moving left
			
		"attacking":
			sprite.play("atk1")
			if sprite.frame == sprite.sprite_frames.get_frame_count("atk1") - 1:
				print('finished attacking, now idle')
				sprite.frame_progress = 0
				shootCounter = 0
				set_state("idle")
				return
				
			sprite.flip_h = toTargetVec.x < 0
			if sprite.frame == 9 and prevFrame != sprite.frame:
				shootCounter += 1
				parent.attackNode.shoot(toTargetVec.angle())
			
			if sprite.frame == 11 and shootCounter < shootPerAttack and prevFrame != sprite.frame:
				print('shoot again pls')
				sprite.frame = 7
				
			prevFrame = sprite.frame
		"idle":
			idleTimer -= delta
			
			if idleTimer < 0:
				print('finished idle, now moving')
				idleTimer = idleDur
				
#				set move dir once here so the pirate doesnt spaz out 
				moveDir = toTargetVec
				var tangent = moveDir.rotated([-1,1].pick_random() * PI/2)
				if moveDir.length() < hoverDistance:
					moveDir = moveDir * -1
				moveDir = moveDir + tangent
				
				set_state("moving")
			
			sprite.flip_h = toTargetVec.x < 0
			sprite.play("idle")
	pass

# need to be overwritten
func _state_logic(delta):
	
	match MovementStyle:
		MovementStyles.Chase:
			chase(delta)
		MovementStyles.Hover:
			hover(delta)
	

	
func _get_transition(delta):
	return null

func _enter_state(new_state, old_state):
	pass
	
func _exit_state(old_state,new_state):
	pass
	
func update_animation(direction: Vector2):
	if direction.length() == 0:  # If not moving, play idle animation
		if sprite.animation != "idle":
			sprite.play("idle")
		return

	if sprite.animation != "walk_right":  # Play only if not already playing
		sprite.play("walk_right")

	sprite.flip_h = direction.x < 0  # Flip when moving left
