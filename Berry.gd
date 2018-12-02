extends KinematicBody2D



func _ready():
	if randf() < 0.5:
		$Sprite.flip_h = true
	$Sprite.rotation = rand_range(-0.3, 0.3)

	$AnimationPlayer.play("growing")
	$AnimationPlayer.queue("default")


func ripen():
	$AnimationPlayer.play("default")


func eat():
	$AnimationPlayer.play("eating")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "eating":
		queue_free()
