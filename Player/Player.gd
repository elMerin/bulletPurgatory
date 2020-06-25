extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

export var ACCELERATION = 4000
export var MAX_SPEED = 500
export var ROLL_SPEED = 125
export var FRICTION = 2500
export var SPEEDBOOST_FACTOR = 1.5

var velocity = Vector2.ZERO
var recoilVelocity = Vector2(0,MAX_SPEED)
var roll_vector = Vector2.ZERO
var stats = PlayerStats
var cooldown = false
var rollCooldown = false
var rolling = false
var speedBoost = false

onready var hurtBox = $Hurtbox

func _ready():
	randomize()
	stats.connect("no_health", self, "noHealth")
	
func _physics_process(delta):
	movement(delta)
			
func movement(delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	#input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	if Input.is_action_just_pressed("roll") && input_vector!=Vector2.ZERO:
		if !rollCooldown:
			rolling = true
			rollCooldown = true
			roll_vector = input_vector
			get_node("evade").play()
			$Roll.play("Roll")
		else:
			get_node("fail").play()
	if Input.is_action_just_pressed("attack"):
		if !cooldown:
			$Attack.play("Attack")
		else:
			get_node("fail").play()
	
	if rolling:
		if !speedBoost:
			velocity = Vector2(roll_vector.x*(MAX_SPEED*2),velocity.y)
		else:
			velocity = Vector2(roll_vector.x*(MAX_SPEED*2*SPEEDBOOST_FACTOR),velocity.y)
	elif input_vector != Vector2.ZERO:
		if !speedBoost:
			velocity = velocity.move_toward(input_vector*MAX_SPEED, ACCELERATION*delta)
		else:
			velocity = velocity.move_toward(input_vector*MAX_SPEED*SPEEDBOOST_FACTOR, ACCELERATION*2*delta)
	else:
		if !speedBoost: 
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
	
	move()
	
	
func move():
	velocity = move_and_slide(velocity)		
			

func recoilRecover():
	velocity.y = -1000
	
func animationStart():
	cooldown = true
	velocity.y = 1000
	
func reloaded():
	cooldown = false
	
func roll_animation_finished():
	rolling = false
	
func roll_cooldown_finished():
	rollCooldown = false
	
func noHealth():
	visible = false
	get_tree().current_scene.reload()
	
func quickFire():
	$QuickfireTimer.start()
	$Quickfire.play("Quickfire")
	
func _on_QuickfireTimer_timeout():
	$Quickfire.stop()
	
func speedBoost():
	speedBoost = true
	$speedBoostTimer.start()

func _on_speedBoostTimer_timeout():
	speedBoost = false

func attackSpeedBoost():
	$Attack.playback_speed = 3
	$attackSpeedBoostTimer.start()


func _on_attackSpeedBoostTimer_timeout():
	$Attack.playback_speed = 1


