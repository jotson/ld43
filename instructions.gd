extends Control

func _ready():
	$Berry.ripen()


func _on_BackButton_pressed():
	get_tree().change_scene("res://start.tscn")
