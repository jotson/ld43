extends KinematicBody2D

var FLOOR_NORMAL = Vector2(0, -1)

var GRAVITY = 500.0 # pixels/s/s
var velocity = Vector2()
var speed = 0.0 # horizontal speed

var energy = 0.0 # total energy
var ENERGY_DRAIN = 5 # energy lost per second
var ENERGY_BERRY = 100.0 # energy gained per fruit
var ENERGY_LEAF = 50.0 # energy gained per leaf

var state = 'default';


func _ready():
	randomize()

	$AnimationPlayer.play("default")
	$AnimationPlayer.seek(rand_range(0, $AnimationPlayer.current_animation_length))

	$directionTimer.wait_time = rand_range(1,4)

	energy = rand_range(70, 99)

	$BalloonSprite.hide()

	choose_direction()


func _physics_process(delta):
	var width = get_viewport().size.x
	var height = get_viewport().size.y

	state = $AnimationPlayer.current_animation

	if position.x > width + 16:
		position.x = -16
	if position.x < -16:
		position.x = width + 16
	if position.y <= 0:
		$BalloonSprite/AnimationPlayer.play("popping")
		$AnimationPlayer.play("falling")


	if state == 'flying':
		velocity.x = 0;
		velocity.y = -50;
	else:
		velocity.y += GRAVITY * delta;

	var motion = velocity;

	move_and_slide(motion, FLOOR_NORMAL)

	find_berry()

	if is_on_floor():
		if state == 'falling':
			$AnimationPlayer.play("default")

		energy -= ENERGY_DRAIN * delta
		if energy < 25.0:
			modulate = Color(8, 1, 1)
		elif energy < 70.0:
			modulate = Color(lerp(8, 1, (energy-25.0)/(70.0-25.0)), 1, 1)
		else:
			modulate = Color(1, 1, 1)

	if energy <= 0:
		modulate = Color(1, 1, 1)
		set_physics_process(false)
		die()


func find_berry():
	if state != 'default':
		return

	for berry in get_tree().get_nodes_in_group('berries'):
		if berry.position.x > position.x - 8 and berry.position.x < position.x + 8:
			velocity.x = 0
			$BalloonSprite.show()
			$BalloonSprite/AnimationPlayer.play("inflating")
			$BalloonSprite/AnimationPlayer.queue("default")
			$AnimationPlayer.play("inflating")
			$AnimationPlayer.queue("flying")
			break


func die():
	$AnimationPlayer.play("dying")
	$AnimationPlayer.queue("dead")
	$deathTimer.start()


func _on_deathTimer_timeout():
	queue_free()


func _on_directionTimer_timeout():
	choose_direction()


func choose_direction():
	speed = rand_range(10, 50)
	if randf() < 0.5:
		velocity.x = speed
	else:
		velocity.x = -speed
	pass


func _on_frog_animation_finished(anim_name):
	pass


func _on_balloon_animation_finished(anim_name):
	if anim_name == 'popping':
		$BalloonSprite.hide()
