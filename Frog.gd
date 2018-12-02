extends KinematicBody2D

var FLOOR_NORMAL = Vector2(0, -1)

var GRAVITY = 500.0 # pixels/s/s
var velocity = Vector2()
var speed = 0.0 # horizontal speed

var energy = 0.0 # total energy
var ENERGY_DRAIN = 5 # energy lost per second
var ENERGY_BERRY = 100.0 # energy gained per fruit
var ENERGY_LEAF = 50.0 # energy gained per leaf

var state = 'default'
var berry = null

var Burst = preload("res://Burst.tscn")


func _ready():
	randomize()

	$AnimationPlayer.play("default")
	$AnimationPlayer.seek(rand_range(0, $AnimationPlayer.current_animation_length))

	$directionTimer.wait_time = rand_range(1,4)

	energy = rand_range(70, 99)

	if randf() < 0.5:
		$Sprite.flip_h = true

	$BalloonSprite.hide()

	var burst = Burst.instance()
	burst.position = Vector2()
	add_child(burst)

	choose_direction()

	Game.births += 1


func _physics_process(delta):
	var width = get_viewport().size.x
	var height = get_viewport().size.y

	state = $AnimationPlayer.current_animation

	if position.x > width + 16:
		position.x = -16
	if position.x < -16:
		position.x = width + 16
	if position.y <= 0:
		pop_balloon()

	if state == 'flying':
		velocity.x = 0;
		velocity.y = -50;
		$Control.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		velocity.y += GRAVITY * delta;

	var motion = velocity;

	move_and_slide(motion, FLOOR_NORMAL)

	# Check for berry collision
	if get_slide_count() and state == 'flying':
		var collider = get_slide_collision(0).collider
		if collider.is_in_group('berries') or collider.is_in_group('leaves'):
			get_berry(collider)

	if is_on_floor():
		if state == 'falling':
			$AnimationPlayer.play("default")
			$flyTimer.start()

		if berry:
			eat()
		else:
			find_berry()
			energy -= ENERGY_DRAIN * delta

		reproduce()

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


func reproduce():
	if not $busyTimer.is_stopped():
		return

	if state != 'default':
		return

	if energy < 100:
		return

	velocity.x = 0
	$AnimationPlayer.play("busy")
	$busyTimer.start()


func _on_busyTimer_timeout():
	$AnimationPlayer.play("clone")


func get_berry(b):
	if b.get_node("AnimationPlayer").current_animation != "default":
		return

	pop_balloon()

	b.get_parent().remove_child(b)
	b.position = Vector2(0, 16)
	b.get_node("CollisionShape2D").disabled = true
	if b.is_in_group('berries'):
		b.remove_from_group('berries')
	if b.is_in_group('leaves'):
		b.remove_from_group('leaves')
	add_child(b)
	berry = b


func find_berry():
	if state != 'default':
		return

	if berry:
		return

	if not $flyTimer.is_stopped():
		return

	var found = false

	for b in get_tree().get_nodes_in_group('berries'):
		if b.get_node("AnimationPlayer").current_animation == "default" and b.position.x > position.x - 8 and b.position.x < position.x + 8:
			found = true
			velocity.x = 0
			$BalloonSprite.show()
			$BalloonSprite/AnimationPlayer.play("inflating")
			$BalloonSprite/AnimationPlayer.queue("default")
			$AnimationPlayer.play("inflating")
			$AnimationPlayer.queue("flying")
			break

	if not found and energy < 50:
		for b in get_tree().get_nodes_in_group('leaves'):
			if b.position.x > position.x - 8 and b.position.x < position.x + 8:
				velocity.x = 0
				$BalloonSprite.show()
				$BalloonSprite/AnimationPlayer.play("inflating")
				$BalloonSprite/AnimationPlayer.queue("default")
				$AnimationPlayer.play("inflating")
				$AnimationPlayer.queue("flying")
				break


func die():
	$BalloonSprite.hide()
	$AnimationPlayer.play("dying")
	$AnimationPlayer.queue("dead")
	$deathTimer.start()
	remove_from_group('frogs')

	Game.deaths += 1


func eat():
	if not $eatingTimer.is_stopped():
		return

	$AnimationPlayer.play("eating")
	berry.eat()
	$eatingTimer.start()


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


func _on_frog_animation_started(anim_name):
	state = anim_name


func _on_frog_animation_finished(anim_name):
	if anim_name == 'clone':
		energy = energy / 2.0

		var Frog = load("res://Frog.tscn")
		var new_frog = Frog.instance()
		get_parent().add_child(new_frog)
		new_frog.position = position + Vector2(16, 0)

		$AnimationPlayer.play("default")

		choose_direction()


func _on_balloon_animation_finished(anim_name):
	if anim_name == 'popping':
		$BalloonSprite.hide()


func pop_balloon():
	$BalloonSprite/AnimationPlayer.play("popping")
	$AnimationPlayer.play("falling")


func _on_Control_gui_input(ev):
	if ev is InputEventMouseButton:
		if $BalloonSprite.visible and $BalloonSprite/AnimationPlayer.current_animation != 'popping':
			pop_balloon()
			$Control.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_eatingTimer_timeout():
	berry = null
	$AnimationPlayer.play("default")
	energy += ENERGY_BERRY
