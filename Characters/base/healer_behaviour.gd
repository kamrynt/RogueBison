extends Node

@onready var companion = get_parent()
@export var heal_delay: float = 0.5

func _ready():
	# Run only once on ready
	if companion and companion.mode == "healer":
		print("💖 Healer mode confirmed")
		run_heal()
	else:
		print("⛔ Not in healer mode, skipping")
		set_process(false)

func run_heal() -> void:
	await get_tree().create_timer(heal_delay).timeout

	var player_node = get_node_or_null(companion.player)
	if player_node:
		var health_component = player_node.get_node_or_null("HealthComponent")
		if health_component and health_component.has_method("heal_to_full"):
			health_component.heal_to_full()
			print("✅ Healed to full health")
		else:
			print("⚠️ HealthComponent missing or broken")
	else:
		print("⚠️ Player not found!")

	# Only disappear in healer mode (safe)
	if companion.mode == "healer":
		print("🦬 Healer companion disappearing...")
		companion.queue_free()
