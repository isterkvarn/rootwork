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


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	do_step()

# Do a time step
func do_step():
	print("do step")
	
	set_cell(-1, -1, 2)
	typeof(get_used_cells()[0])
	var rule = SpawnRule.new(1, 1)
	#print(get_root_neighbours(Vector2(0, 0)))

func place_root(coord : Vector2):
	set_cell(coord.x, coord.y, ROOT)
	
# Determine if a root should be spawned on the coordinate
func should_spawn(coord : Vector2) -> bool:
	print(get_root_neighbours(Vector2(1, 1)))
	return true

# Get the number of root neighbours
func get_root_neighbours(root : Vector2) -> int:
	var num : int = 0
	
	for i in range(9):
		if i == 4:
			continue
			
		var neighbour = Vector2(i / 3 - 1, i % 3 - 1)
	
		if get_cell(neighbour.x, neighbour.y) == ROOT:
			num += 1
		
	return num
		
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
