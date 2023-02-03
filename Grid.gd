extends TileMap

const BACKGROUND : int = 0
const ROOT : int = 1
const PISS : int = 2

class SpawnRule:
	var root_num : int # The number of roots needed in the vicinity
	var root_range : int # The range which the roots must be within
	
	func _init(root_num_in : int, root_range_in):
		root_num = root_num_in
		root_range = root_range_in
	
	# Check if a root should be spawned on the square
	func should_spawn() -> bool:
		return true
		

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	do_step()

# Do a time step
func do_step():
	print("do step")
	
	set_cell(-1, -1, 2)
	print(get_used_cells()[0])
