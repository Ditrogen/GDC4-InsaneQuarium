extends Node2D

var food = preload("res://Scenes/pellet.tscn")
var fish = preload("res://Scenes/fish.tscn")
var coin = preload("res://Scenes/coin.tscn")

@onready var coinLabel = $Panel/ColorRect/coinLabel
@onready var timeLabel = $Panel/ColorRect2/timeLabel
@onready var Lminutes = $Panel/ColorRect2/minutes
@onready var Lseconds = $Panel/ColorRect2/seconds
@onready var eggLabel = $Panel/ColorRect5/eggCount

var foodLimit = 2
var eggLevel = 0
var eggCost = 300

var time: float = 0.0
var seconds: int = 0
var minutes: int = 0

func _ready():
	update_money()
	GameState.money = 1000
	

func _process(delta):
	get_time(delta)
	update_money()
	gameOver()

func _on_clickable_area_button_down():
	if GameState.money >= 10 && get_node("Pellets").get_child_count() < foodLimit:
		GameState.money -= 10
		var obj = food.instantiate()
		obj.position = get_global_mouse_position()
		get_node("Pellets").add_child(obj)

func _on_border_bottom_body_entered(body):
	if body.is_in_group("Pellet_group"):
		body.queue_free()

func _on_button_pressed():
	if GameState.money >= 100:
		GameState.money -= 100	
		var obj = fish.instantiate()
		obj.position = Vector2(randi_range(480,1440),randi_range(150,968))
		get_node("Fishes").add_child(obj)
	

func update_money():
	coinLabel.text = str(GameState.money)

func get_time(delta):
	time += delta
	seconds = fmod(time,60)
	minutes = fmod(time,3600) / 60
	Lminutes.text = "%02d:" % minutes
	Lseconds.text = "%02d" % seconds


func _on_up_food_limit_pressed():
	if GameState.money >= 200:
		GameState.money -= 200
		foodLimit += 1


func _on_egg_button_pressed():
	if GameState.money >= eggCost:
		GameState.money -= eggCost
		eggLevel += 1
		eggCost += 50
		eggLabel.text = str(eggLevel) + "/3"
		$Panel/eggButton.text = "$" + str(eggCost)
	if eggLevel == 3:
		win()

func paused():
	get_tree().paused = true
	$"pause menu".show()

func unpaused():
	$"pause menu".hide()
	get_tree().paused = false

func mainMenu():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func restart():
	get_tree().paused = false
	get_tree().reload_current_scene()

func gameOver():
	if get_node("Fishes").get_child_count() <= 0 && GameState.money < 100:
		get_tree().paused = true
		$"game over".show()

func win():
	get_tree().paused = true
	$win.show()


