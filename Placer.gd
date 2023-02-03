extends Node2D

var roots_in_inv : int = 10
const ITERATION_THRESHOLD = 100
var current_iteration_value = 0
var iterate = false


onready var grid = get_parent().get_node("Grid")



func _process(delta):

	# Wait for player input to place cells
	if Input.is_action_just_pressed("place") and roots_in_inv > 0 and not iterate:
		var mouse_pos = grid.world_to_map(get_global_mouse_position())
		var did_place : bool = grid.place_root(mouse_pos)
		
		# Only remove from inv if place was successfull
		if did_place:
			roots_in_inv -= 1
			
	#print(current_iteration_value)
	if iterate:
		current_iteration_value += 1
		#grid.next_generation()

func _input(event):
	if event is InputEventKey and event.pressed:
		
		# one iteraton at the time
		if event.scancode == KEY_H:
			#print("jump one iteration")
			current_iteration_value += 1
			#grid.next_generation()
			
		# start generating each step
		if event.scancode == KEY_J:
			#print("start iterating")
			iterate = true
			
		# stop generating each step
		if event.scancode == KEY_K:
			#print("stop iterating")
			iterate = false
			
		# L
		if event.scancode == KEY_L:
			print("L")
