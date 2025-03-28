extends CanvasLayer

@onready var label = $Label
@onready var label2 = $Label2
@onready var label3 = $Label3
@onready var label4 = $Label4
@onready var player = %Character
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.get_node("UserMovementComponent").connect("movement_signal", _update_label)
	player.get_node("AttackComponent").connect("attack_signal", _update_label2)
	player.get_node("HealthComponent").connect("health_signal", _update_label3)
	Globals.hoverItem.connect(_update_label4)
	
func _update_label(newState):
	label.text = newState
func _update_label2(newState):
	label2.text = newState
func _update_label3(newState):
	label3.text = newState
func _update_label4(item: ItemBase):
	if item == null:
		label4.text = "not hovering item"
	else:
		label4.text = item.itemName
