extends CanvasLayer

@onready var label = $Label
@onready var label2 = $Label2
@onready var label3 = $Label3
@onready var player = %Character

func _ready() -> void:
	player = get_node_or_null("res://Characters/base/PlayerCharacterBase.gd") 

	if player:
		player.get_node("UserMovementComponent").connect("movement_signal", _update_label)
		player.get_node("AttackComponent").connect("attack_signal", _update_label2)
		player.get_node("HealthComponent").connect("health_signal", _update_label3)
	else:
		print("Error: Player not found!")

func _update_label(newState):
	label.text = newState

func _update_label2(newState):
	label2.text = newState

func _update_label3(newState):
	label3.text = newState
