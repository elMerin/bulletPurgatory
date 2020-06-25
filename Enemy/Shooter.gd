extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 500
export var ROLL_SPEED = 125
export var FRICTION = 1000
export(float) var fireSpeed = 1

var velocity = Vector2.ZERO
var active = false
var paused = false

signal noHealth

func setActive():
	paused = false
	active = true
	$Timer.wait_time = 1.0/fireSpeed
	$Timer.start()
	$BulletSpawner.fire()


func _process(delta):
	if paused:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)

	else:
		if position.y <= 50:
			velocity = velocity.move_toward(Vector2(0,200), ACCELERATION*delta)
		elif !active:
			for child in $Dialog.get_children():
				child.start()
			$activeTimer.start()
			paused = true
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
		if active:
			var player = get_parent().get_node("Player")
			if player != null:	
				accelerate_towards_point(player.global_position, delta)
	velocity = move_and_slide(velocity)	

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(Vector2(direction.x,0)*MAX_SPEED, ACCELERATION*delta)

func _on_Timer_timeout():
	$BulletSpawner.fire()


func _on_activeTimer_timeout():
	setActive()
	
func _on_Stats_no_health():
	get_tree().current_scene.get_node("Sounds/die").play()
	emit_signal("noHealth")
	queue_free()
