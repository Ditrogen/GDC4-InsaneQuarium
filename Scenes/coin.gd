extends RigidBody2D

func _on_texture_button_pressed():
	GameState.money += 25
	self.queue_free()
