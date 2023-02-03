extends Node2D

var roots_in_inv : int = 0
onready var grid = get_parent().get_node("Grid")



func _process(delta):
	
	# Wait for player input to place cells
	if Input.is_action_just_pressed("place"):
		var mouse_pos = grid.world_to_map(get_global_mouse_position())
		var did_place : bool = grid.place_root(mouse_pos)
		
		# Only remove from inv if place was succesful
		if did_place:
			roots_in_inv -= 1
