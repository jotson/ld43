extends KinematicBody2D


func _ready():
	if randf() < 0.5:
		$Sprite.flip_h = true
	$Sprite.rotation = rand_range(0, 2*PI)

	$AnimationPlayer.queue("default")

	scale = Vector2(0,0)
	$Tween.interpolate_property(self, 'scale', Vector2(0.0, 0.0), Vector2(1.5, 1.5), 0.3, Tween.TRANS_CIRC, Tween.EASE_IN)
	$Tween.interpolate_property(self, 'scale', Vector2(1.5, 1.5), Vector2(1, 1), 0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT, 0.3)
	$Tween.start()

	$sfxAppear.play()


func ripen():
	pass


func eat():
	queue_free()
