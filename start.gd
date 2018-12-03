extends Control


func _ready():
	$sfxPop.play()

	$Berry.ripen()

	$Tween.interpolate_property($Label, 'modulate', Color(1,1,1,0), Color(1,1,1,1), 2.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.interpolate_property($Label, 'rect_scale', Vector2(5,5), Vector2(1,1), 1.0, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$Tween.start()


func _on_StartBtn_pressed():
	get_tree().change_scene("res://main.tscn")


func _on_InstructionsButton_pressed():
	get_tree().change_scene("res://instructions.tscn")


func _on_yafdButton_pressed():
	OS.shell_open("https://twitter.com/yafd")


func _on_githubButton_pressed():
	OS.shell_open("https://github.com/jotson/ld43")


func _on_Label_mouse_entered():
	$Tween.interpolate_property($Label, 'rect_scale', Vector2(1.1,1.1), Vector2(1,1), 1.0, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$Tween.start()


func _on_Label_mouse_exited():
	$Tween.interpolate_property($Label, 'rect_scale', Vector2(1.1,1.1), Vector2(1,1), 1.0, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$Tween.start()


func _on_frogControl_mouse_entered():
	ribit()


func _on_frogControl_mouse_exited():
	ribit()


func _on_frogControl_gui_input(ev):
	if ev is InputEventMouseButton and ev.pressed:
		ribit()


func ribit():
	$sfxRibit.play()
	$Tween.interpolate_property($Frog/Sprite, 'scale', Vector2(2,1), Vector2(1,1), 1.0, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$Tween.start()


func _on_MusicButton_pressed():
	var bus = AudioServer.get_bus_index("Music")
	if AudioServer.is_bus_mute(bus):
		AudioServer.set_bus_mute(bus, false)
	else:
		AudioServer.set_bus_mute(bus, true)
