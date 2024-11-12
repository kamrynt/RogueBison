extends Node2D
@onready var main = get_tree().get_root().get_node("Main2D")
@onready var enemy = load("res://Characters/enemies/orc.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(10):
		var instance: NPCCharacterBase = enemy.instantiate()
		instance.set_target(%Character)
		instance.position = Vector2(randi_range(0, 1000),randi_range(0, 900))
		main.add_child.call_deferred(instance)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
