extends CharacterBody2D  # or Node3D or whatever your base is

@onready var inspect_ray = $InspectRay  # This connects to the RayCast3D we added

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		if inspect_ray.is_colliding():
			var target = inspect_ray.get_collider()
			if target and target.is_in_group("inspectable"):
				target.inspect()
