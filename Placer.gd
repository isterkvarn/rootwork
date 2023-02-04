extends Node2D

var roots_in_inv : int = 3
const ITERATION_THRESHOLD = 0.05
var current_iteration_value = 0
var iterate = false


onready var grid = get_parent().get_node("Grid")



func _process(delta):

	# Wait for player input to place cells
	if Input.is_action_pressed("place") and roots_in_inv > 0:
		var mouse_pos = grid.world_to_map(get_global_mouse_position())
		if grid.get_num_of_neighbours(mouse_pos) > 0:
			var did_place : bool = grid.place_root(mouse_pos)
			
			# Only remove from inv if place was successfull
			if did_place:
				roots_in_inv -= 1
			
	if iterate:
		current_iteration_value += delta
	
	if current_iteration_value >= ITERATION_THRESHOLD:
		current_iteration_value = 0
		grid.do_step()

func _input(event):
	if event is InputEventKey and event.pressed:
		
		# start generating each step
		if event.scancode == KEY_SPACE:
			#print("start iterating")
			change_iterate()
		
		# one iteraton at the time
		if event.scancode == KEY_S:
			#print("jump one iteration")
			current_iteration_value += 1
			grid.do_step()
			
		# L
		if event.scancode == KEY_L:
			print("L")

func change_iterate():
	iterate = not iterate
	
func add_to_inventory(num):
	roots_in_inv += num
	
func get_roots_in_inventory():
	return roots_in_inv
