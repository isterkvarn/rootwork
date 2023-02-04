extends TileMap

const BACKGROUND : int = 0
const ROOT : int = 1
const ROOT_INDEXES = [1, 2, 3, 4, 5]
const PISS : int = 6
const BASE_NEIGHBOUR_THRESHOLD = 4
const PISS_AREA = 10000
const NUM_OF_PISS = 20000
const TURN_THRESHOLD = 7

var rng = RandomNumberGenerator.new()
var new_roots = []
var neighbour_threshold = BASE_NEIGHBOUR_THRESHOLD
var score = 0
var gen_queue = null

onready var placer = get_parent().get_node("Placer")

class Generation:
	var roots : Array = []
	var life_time : int = 0
	
	func _init(roots_in : Array, life_time_in : int):
		roots = roots_in
		life_time = life_time_in

class Queue:
	var queue : Array = []
	const size : int = 5
	const life_time : Array = [4, 3, 2, 1, 1]
	
	func _init():
		for i in range(size):
			queue.append([])
	
	func add_roots(roots : Array):
		var gen = Generation.new(roots, 0)
		queue[0].append(gen)
	
	func get_gen(gen_num : int) -> Array:
		var roots : Array = []
		
		for gen in queue[gen_num]:
			roots += gen.roots
		
		return roots
	
	func do_iteration():
		for i in range(len(queue)):
			for gen in queue[i]:
				gen.life_time += 1

				# If the gen has passed its lifetime, move it further
				# further down the queue
				if gen.life_time >= life_time[i]:
					if i < size - 1:
						gen.life_time = 0
						queue[i + 1].append(gen)
					queue[i].erase(gen)

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	new_roots = get_used_cells()
	score += len(new_roots)
	spread_the_piss()
	gen_queue = Queue.new()

# Do a time step
func do_step():	
	var spawns = []
	
	if not new_roots:
		placer.change_iterate()
	
	for root in new_roots:
		if get_num_of_neighbours(root) > neighbour_threshold:
			continue
			
		var piss_neighbours = get_piss_neighbours(root)
			
		if not piss_neighbours:
		
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
		else:
			spawns.append(piss_neighbours[0])

	gen_queue.add_roots(new_roots)
	gen_queue.do_iteration()
	new_roots = []
	for root in spawns:
		place_root(root)
	

func place_root(coord : Vector2):
	new_roots.append(coord)
	if not is_root(get_cell(coord.x, coord.y)):
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
		
		if is_root(get_cell(neighbour.x, neighbour.y)):
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
		
		if not is_root(get_cell(neighbour.x, neighbour.y)):
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
	
func get_piss_neighbours(root):
	var piss_neighbours = []
	
	for i in range(9):
		if i == 4:
			continue
			
		var neighbour = Vector2(i/3 + root.x - 1, i%3 + root.y - 1)
		
		if get_cell(neighbour.x, neighbour.y) == PISS:
			piss_neighbours.append(neighbour)
		
	return piss_neighbours

func is_root(cell):
	return cell in ROOT_INDEXES
