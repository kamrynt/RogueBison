extends CanvasLayer

@onready var label = $Label
@onready var label2 = $Label2
@onready var label3 = $Label3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().get_node("Character").get_node("MovementComponent").connect("movement_signal", _update_label)
	get_parent().get_node("Character").get_node("AttackComponent").connect("attack_signal", _update_label2)
	get_parent().get_node("Character").get_node("HealthComponent").connect("health_signal", _update_label3)

func _update_label(newState):
	label.text = newState
func _update_label2(newState):
	label2.text = newState
func _update_label3(newState):
	label3.text = newState
