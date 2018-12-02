extends Node2D

var Berry = preload("res://Berry.tscn")
var Frog = preload("res://Frog.tscn")


func _ready():
	randomize()

	var width = get_viewport().size.x
	var height = get_viewport().size.y

	# Add berries
	for i in range(8):
		var b = Berry.instance()
		b.position = Vector2(rand_range(16, width-16), rand_range(16, 80))
		add_child(b)
		b.ripen()

	# Add frogs
	for i in range(8):
		var f = Frog.instance()
		f.position = Vector2(rand_range(16, width-16), 520)
		add_child(f)
