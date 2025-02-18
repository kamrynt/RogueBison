extends CharacterBody2D

@export var companion_scene: PackedScene  # Drag your Companion scene in the Inspector
@onready var cooldown_timer = $CooldownTimer  # Reference the Timer
@onready var cooldown_label = $HUD/CooldownLabel  # Label for cooldown text
@onready var cooldown_bar = $HUD/CooldownBar  # Progress bar (optional)

var is_on_cooldown = false

func summon_companion():
    if is_on_cooldown:
        print("Companion is on cooldown!")
        return

    var companion = companion_scene.instantiate()
    get_tree().current_scene.add_child(companion)  # Spawn companion in the game

    start_cooldown(10)  # Example: Companion active for 10 seconds

func start_cooldown(duration: float):
    is_on_cooldown = true
    cooldown_timer.wait_time = duration
    cooldown_timer.start()

func _on_CooldownTimer_timeout():
    is_on_cooldown = false
    cooldown_label.text = "Ready!"  # Update text
    cooldown_bar.value = 100  # Reset progress bar

func _process(delta):
    if is_on_cooldown:
        cooldown_label.text = "Cooldown: %.1f" % cooldown_timer.time_left
        cooldown_bar.value = (cooldown_timer.time_left / cooldown_timer.wait_time) * 100

func _input(event):
    if event.is_actionpressed("summon_companion")"
        summon_companion()

func _ready():
    await get_tree().create_timer(10).timeout
    queue_free() # Removes the companion after 10 seconds
