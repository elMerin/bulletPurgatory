extends KinematicBody2D


export var ACCELERATION = 1000
export var MAX_SPEED = 1000
export var ROLL_SPEED = 125
export var FRICTION = 1000
export var DIVE_VELOCITY = 2000
export var DIVE_ACCELERATION = 2000

var diving = false
var velocity = Vector2.ZERO
var active = false
var paused = false

signal diverFell
signal noHealth

func setActive():
	active = true
	paused = false
	$diveTimer.start()

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
			if(position.y >= 1500):
				emit_signal("diverFell")
				queue_free()
			if !diving:
				var player = get_parent().get_node("Player")
				if player != null:	
					accelerate_towards_point(player.global_position, delta)
				if(global_position.x>player.global_position.x-50 && global_position.x<player.global_position.x+50):
					velocity = Vector2.ZERO
					diving = true
					$diveTimer.stop()
			else:
				velocity = velocity.move_toward(Vector2(0,DIVE_VELOCITY), DIVE_ACCELERATION*delta)
	velocity = move_and_slide(velocity)	

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(Vector2(direction.x,0)*MAX_SPEED, ACCELERATION*delta)

func _on_diveTimer_timeout():
	velocity = Vector2.ZERO
	diving = true
	
func _on_Hitbox_area_entered(area):
	PlayerStats.health -= $Hitbox.damage
	get_tree().current_scene.get_node("Sounds/hit").play()

func _on_activeTimer_timeout():
	setActive()
	
func _on_Stats_no_health():
	get_tree().current_scene.get_node("Sounds/die").play()
	emit_signal("noHealth")
	queue_free()
