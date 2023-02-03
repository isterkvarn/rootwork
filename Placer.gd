extends Node2D

var cells_in_inv : int = 0
onready var grid = get_parent().get_node("Grid")



func _process(delta):
	
	# wait for player input to place cells
	if Input.is_action_just_pressed("place"):
		var mouse_pos = get_global_mouse_position()
		var did_place : bool= grid.place_cell(mouse_pos)
		
		# Only remove from inv if place was succesful
		if did_place:
			cells_in_inv -= 1
