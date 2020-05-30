extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

export var ACCELERATION = 4000
export var MAX_SPEED = 1000
export var ROLL_SPEED = 125
export var FRICTION = 2500

var velocity = Vector2.ZERO
var recoilVelocity = Vector2(0,MAX_SPEED)
var roll_vector = Vector2.ZERO
var stats = PlayerStats
var cooldown = false
var rollCooldown = false
var rolling = false

onready var animationPlayer = $AnimationPlayer
onready var hurtBox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _ready():
	randomize()
	stats.connect("no_health", self, "queue_free")
	
func _physics_process(delta):
	movement(delta)
			
func movement(delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	#input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	if Input.is_action_just_pressed("roll") && !rollCooldown && input_vector!=Vector2.ZERO:
		rolling = true
		rollCooldown = true
		roll_vector = input_vector
		get_parent().get_node("evade").play()
		$Roll.play("Roll")
	if Input.is_action_just_pressed("attack"):
		if !cooldown:
			$Attack.play("Attack")
		else:
			get_parent().get_node("fail").play()
	
	if rolling:
		velocity = velocity.move_toward(Vector2(roll_vector.x*(MAX_SPEED*5),velocity.y), (ACCELERATION*5)*delta)
	elif input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector*MAX_SPEED, ACCELERATION*delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
	
	move()
	
	
	
func move():
	velocity = move_and_slide(velocity)		
	

var damaged = false

func _on_Hurtbox_area_entered(area):
	if !damaged:
		stats.health -= area.damage
		damaged = true
		hurtBox.start_invincibility(0.6)
		hurtBox.create_hit_effect(true)
		var playerHurtSound = PlayerHurtSound.instance()
		get_tree().current_scene.add_child(playerHurtSound)
				
	
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


