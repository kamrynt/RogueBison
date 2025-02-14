extends StaticBody2D

# Function to trigger trap effect when the player steps on it
func _on_body_entered(body):
	if body.is_in_group("Player"):  # Assuming the player is in the "Player" group
		body.take_damage(10)  # Call a damage function in Player.gd
		queue_free()  # Remove trap after activation
