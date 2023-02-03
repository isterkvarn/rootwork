extends Node2D
const ITERATION_THRESHOLD = 100
var current_iteration_value = 0
var iterate = true

onready var grid = get_parent().get_node("Grid")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(current_iteration_value)
	if iterate:
		current_iteration_value += 1
	if Input.is_action_just_pressed("place"):
		pass

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_H:
			print("jump one iteration")
			current_iteration_value = 0
		if event.scancode == KEY_J:
			print("start iterating")
			iterate = true
		if event.scancode == KEY_K:
			print("stop iterating")
			iterate = false
		if event.scancode == KEY_L:
			print("L")
