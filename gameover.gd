extends Control

func _ready():
	if Game.leaves <= 0:
		$TitleLabel.text = "No more leaves!"
	else:
		$TitleLabel.text = "No more frogs!"

	$FrogsLabel.text = "You had " + str(Game.frogs) + " frogs"
	$BiggestColonyLabel.text = "Your highest population was \n" + str(Game.biggest_colony) + " frogs"
	$TimeLabel.text = "You survived for\n" + str(round(Game.time)) + " seconds"


func _on_RetryButton_pressed():
	get_tree().change_scene('res://main.tscn')
