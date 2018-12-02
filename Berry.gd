extends KinematicBody2D

var Burst = preload("res://Burst.tscn")


func _ready():
	if randf() < 0.5:
		$Sprite.flip_h = true
	$Sprite.rotation = rand_range(-0.3, 0.3)

	$AnimationPlayer.play("growing")
	$AnimationPlayer.queue("default")

	var burst = Burst.instance()
	burst.position = Vector2()
	add_child(burst)


func ripen():
	$AnimationPlayer.play("default")


func eat():
	$AnimationPlayer.play("eating")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "eating":
		queue_free()


func disable_collision():
	$CollisionShape2D.disabled = true


func enable_collision():
	$CollisionShape2D.disabled = false
