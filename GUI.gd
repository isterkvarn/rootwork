extends Control



onready var grid = get_parent().get_parent().get_node("Game").get_node("Grid")
onready var placer = get_parent().get_parent().get_node("Game").get_node("Placer")
onready var score_label = $VBoxContainer/Score
onready var seeds_label = $VBoxContainer/Seeds

const seed_txt = "Seed: "
const score_txt = "Score: "

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	score_label.set_text(score_txt + str(grid.get_score()))
	seeds_label.set_text(seed_txt + str(placer.get_roots_in_inventory()))
