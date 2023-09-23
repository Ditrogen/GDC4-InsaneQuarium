extends Node2D

var food = preload("res://Scenes/pellet.tscn")
var fish = preload("res://Scenes/fish.tscn")


func _on_clickable_area_button_down():
	var obj = food.instantiate()
	obj.position = get_global_mouse_position()
	get_node("Pellets").add_child(obj)

func _on_border_bottom_body_entered(body):
	if body.is_in_group("Pellet_group"):
		body.queue_free()

func _on_button_pressed():
	var obj = fish.instantiate()
	obj.position = Vector2(randi_range(0,1920),randi_range(150,968))
	get_node("Fishes").add_child(obj)
