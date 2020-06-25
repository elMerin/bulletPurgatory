extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 500
export var ROLL_SPEED = 125
export var FRICTION = 1000
export(float) var fireSpeed = 0.5

var velocity = Vector2.ZERO
var active = false
var paused = false

signal noHealth

func setActive():
	active = true
	paused = false
	$Timer.wait_time = 1.0/fireSpeed
	$Timer.start()
	$BoomerangSpawner.fire()
	
func _process(delta):
	if paused:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
	else:
		if position.y <= 50:
			velocity = velocity.move_toward(Vector2(0,250), ACCELERATION*delta)
		elif !active:
			for child in $Dialog.get_children():
				child.start()
			$activeTimer.start()
			paused = true
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
		if active:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
	velocity = move_and_slide(velocity)

func _on_Timer_timeout():
	$BoomerangSpawner.fire()


func _on_activeTimer_timeout():
	setActive()
	
func _on_Stats_no_health():
	get_tree().current_scene.get_node("Sounds/die").play()
	emit_signal("noHealth")
	queue_free()
