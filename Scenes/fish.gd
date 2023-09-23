extends CharacterBody2D

var acceleration = 400
var max_speed = 200
var friction = 250
var foodCount = 0
var hungry = true

var coin = preload("res://coin.tscn")

var food = null

@onready var wanderController = $"Wandering Controller"
@onready var hungryTimer = $Timer
@onready var coinTimer = $CoinTimer

enum {
	IDLE,
	WANDER,
	CHASE,
}

var state = CHASE


func _physics_process(delta):
	
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_food()
			
			if wanderController.get_time_left() <= 0:
				state = pick_random_state([IDLE,WANDER,WANDER])
				wanderController.start_wander_timer(randi_range(1,3))
		WANDER:
			seek_food()
			
			if wanderController.get_time_left() <= 0:
				state = pick_random_state([IDLE,WANDER,WANDER])
				wanderController.start_wander_timer(randi_range(1,3))
				
			var direction = global_position.direction_to(wanderController.target_position)
			velocity = velocity.move_toward(direction*max_speed, acceleration*delta)
				
			if global_position.distance_to(wanderController.target_position) <= 1:
				state = pick_random_state([IDLE, WANDER, WANDER])
				wanderController.start_wander_timer(randi_range(1,3))
			
		CHASE:
			if food != null && hungry:
				var direction = global_position.direction_to(food.global_position)
				velocity = velocity.move_toward(direction*max_speed, acceleration*delta)
			else:
				state = WANDER
	
	move_and_slide()

func seek_food():
	if can_see_food():
		state = CHASE

func can_see_food():
	return food != null

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_food_detection_body_entered(body):
	if body.is_in_group("Pellet_group"):
		food = body

func _on_food_detection_body_exited(body):
	food = null

func _on_eat_area_body_entered(body):
	if body.is_in_group("Pellet_group") && hungry:
		foodCount += 1
		body.queue_free()
		hungry = false
		hungryTimer.start()

func _on_timer_timeout():
	hungry = true


func _on_coin_timer_timeout():
	var obj = coin.instantiate()
	obj.position = global_position
	get_parent().get_parent().get_node("Drops").add_child(obj)
	coinTimer.start()
