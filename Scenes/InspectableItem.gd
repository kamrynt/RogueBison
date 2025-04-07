extends Node3D

@export var inspect_text: String = "It's just an old dusty box..."

func inspect():
	print(inspect_text)
	# Later you can trigger a UI popup or zoom-in here
