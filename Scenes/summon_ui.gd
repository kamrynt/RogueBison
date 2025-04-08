extends CanvasLayer

@onready var mode_panel = $ModePanel
@onready var attack_button = $ModePanel/Attack
@onready var heal_button = $ModePanel/Heal

signal mode_selected(mode: String)

func _ready():
	attack_button.pressed.connect(func(): _on_mode_selected("attacker"))
	heal_button.pressed.connect(func(): _on_mode_selected("healer"))
	mode_panel.visible = false

func toggle_panel():
	mode_panel.visible = !mode_panel.visible

func _on_mode_selected(mode: String):
	mode_panel.visible = false
	emit_signal("mode_selected", mode)
