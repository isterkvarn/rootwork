extends TileMap

const BACKGROUND : int = 0
const ROOT : int = 1
const PISS : int = 2
const BASE_NEIGHBOUR_THRESHOLD = 4
const PISS_AREA = 1000
const NUM_OF_PISS = 200
const TURN_THRESHOLD = 7

var rng = RandomNumberGenerator.new()
var new_roots = []
var last_new_roots = []
var neighbour_threshold = BASE_NEIGHBOUR_THRESHOLD
var score = 0

onready var placer = get_parent().get_node("Placer")

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	new_roots = get_used_cells()
	score += len(new_roots)
	spread_the_piss()

# Do a time step
func do_step():	
	var spawns = []
	
	if not new_roots:
		placer.change_iterate()
		
	
	for root in new_roots:
		if get_num_of_neighbours(root) > neighbour_threshold:
			continue
		
		var cluster = get_spawn_coord(root)
		var spawn_range = [[-1, 1], [-1, 1]]
		
		if cluster.x > TURN_THRESHOLD:
			spawn_range[0][1] = 0
		elif cluster.x < -TURN_THRESHOLD:
			spawn_range[0][0] = 0
		if cluster.y > TURN_THRESHOLD:
			spawn_range[1][1] = 0
		elif cluster.y < -TURN_THRESHOLD:
			spawn_range[1][0] = 0
		
		var spawn_number = 1
		if 0 == rng.randi_range(0,80):
			spawn_number = 2
		
		for i in range(0, spawn_number):
			var neighbour = Vector2(
				rng.randi_range(spawn_range[0][0], spawn_range[0][1]) + root.x,
				rng.randi_range(spawn_range[1][0], spawn_range[1][1]) + root.y
			)
			
			spawns.append(neighbour)

	last_new_roots = new_roots
	new_roots = []
	for root in spawns:
		place_root(root)

func place_root(coord : Vector2):
	new_roots.append(coord)
	if get_cell(coord.x, coord.y) != ROOT:
		score += 1
		if get_cell(coord.x, coord.y) == PISS:
			placer.add_to_inventory(3)
		set_cell(coord.x, coord.y, ROOT)
		return true;
	return false;

func get_random_neighbour(root : Vector2) -> Vector2:
	var i : int = rng.randi_range(0, 8)
	return Vector2(i/3 + root.x - 1, i%3 + root.y - 1)

func get_num_of_neighbours(root : Vector2) -> int:
	var num : int = 0
	
	for i in range(9):
		if i == 4:
			continue
		var neighbour = Vector2(i/3 + root.x - 1, i%3 + root.y - 1)
		
		if get_cell(neighbour.x, neighbour.y) == ROOT:
			num += 1
		
	return num

func get_spawn_coord(root : Vector2) -> Vector2:
	var cluster = Vector2(0, 0)
	var root_range = 5
	
	var neighbours = pow((root_range * 2 + 1), 2)
	
	for i in range(neighbours):
		var neighbour = Vector2(
			i/(root_range*2 + 1) + root.x - root_range,
			i%(root_range*2 + 1) + root.y - root_range
		)
		
		if get_cell(neighbour.x, neighbour.y) != ROOT:
			continue
		
		if neighbour.x < root.x:
			cluster.x += -1
		elif neighbour.x > root.x:
			cluster.x += 1
			
		if neighbour.y < root.y:
			cluster.y += -1
		elif neighbour.y > root.y:
			cluster.y += 1
	
	return cluster

func spread_the_piss():
	for i in range(NUM_OF_PISS):
		set_cell(rng.randi_range(-PISS_AREA,PISS_AREA), rng.randi_range(-PISS_AREA,PISS_AREA), PISS)

func get_score():
	return score
