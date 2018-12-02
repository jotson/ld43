extends Node2D

var Berry = preload("res://Berry.tscn")
var Leaf = preload("res://Leaf.tscn")
var Frog = preload("res://Frog.tscn")


func _ready():
	randomize()

	var width = get_viewport().size.x
	var height = get_viewport().size.y

	# Add leaves
	for i in range(16):
		add_leaf()

	# Add berries
	for i in range(10):
		add_berry(true)

	# Add frogs
	for i in range(3):
		var o = Frog.instance()
		o.position = Vector2(rand_range(16, width-16), 520)
		add_child(o)


func _process(delta):
	Game.time += delta

	var frogs = get_tree().get_nodes_in_group('frogs').size()
	if frogs > Game.biggest_colony:
		Game.biggest_colony = frogs

	find_node("LabelFrog").text = "Frogs: " + str(frogs)
	find_node("LabelTimer").text = "Time: " + str(round(Game.time))


func add_leaf():
	var width = get_viewport().size.x
	var height = get_viewport().size.y

	var o = Leaf.instance()
	o.position = Vector2(rand_range(16, width-16), rand_range(8, 32))
	add_child(o)
	o.ripen()


func _on_leafGrowTimer_timeout():
	if get_tree().get_nodes_in_group('leaves').size():
		add_leaf()


func add_berry(ripen = false):
	var width = get_viewport().size.x
	var height = get_viewport().size.y

	var o = Berry.instance()
	o.position = Vector2(rand_range(16, width-16), rand_range(32, 100))
	add_child(o)
	if ripen:
		o.ripen()


func _on_berryGrowTimer_timeout():
	if get_tree().get_nodes_in_group('leaves').size():
		add_berry()
