extends Node2D

var Berry = preload("res://Berry.tscn")
var Leaf = preload("res://Leaf.tscn")
var Frog = preload("res://Frog.tscn")


func _ready():
	randomize()

	Game.reset()

	var width = get_viewport().size.x
	var height = get_viewport().size.y

	# Add leaves
	add_leaf()
	for i in range(15):
		$AnimationPlayer.queue("add_leaf")

	# Add berries
	for i in range(10):
		$AnimationPlayer.queue("add_berry")

	# Add frogs
	for i in range(3):
		var o = Frog.instance()
		o.position = Vector2(rand_range(16, width-16), 520)
		add_child(o)


func _process(delta):
	Game.time += delta

	Game.frogs = get_tree().get_nodes_in_group('frogs').size()
	if Game.frogs > Game.biggest_colony:
		Game.biggest_colony = Game.frogs
	Game.leaves = get_tree().get_nodes_in_group('leaves').size()

	find_node("LabelFrog").text = "Frogs: " + str(Game.frogs)
	find_node("LabelTimer").text = "Time: " + str(round(Game.time))

	if Game.leaves <= 0 or Game.frogs <= 0:
		set_process(false)
		get_tree().change_scene('res://gameover.tscn')


func add_leaf():
	var width = get_viewport().size.x
	var height = get_viewport().size.y

	var o = Leaf.instance()
	o.position = Vector2(rand_range(16, width-16), rand_range(8, 32))
	add_child(o)
	o.ripen()


func _on_leafGrowTimer_timeout():
	if get_tree().get_nodes_in_group('leaves').size():
		if Game.leaves < 30:
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
		var berries = get_tree().get_nodes_in_group('berries').size()
		if berries > 25:
			return

		var leaves = Game.leaves
		var create = (leaves - 15.0) / 2.0
		if create < 1:
			create = 1
		if create > 5:
			create = 5

		for i in range(create):
			add_berry()
