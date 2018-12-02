extends Control


func _ready():
	$Berry.ripen()


func _on_StartBtn_pressed():
	get_tree().change_scene("res://main.tscn")


func _on_InstructionsButton_pressed():
	get_tree().change_scene("res://instructions.tscn")


func _on_yafdButton_pressed():
	OS.shell_open("https://twitter.com/yafd")


func _on_githubButton_pressed():
	OS.shell_open("https://github.com/jotson/ld43")
