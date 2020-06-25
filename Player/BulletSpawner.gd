extends Node2D

const Bullet = preload("res://Player/Bullet.tscn")
const EnemyBullet = preload("res://Enemy/EnemyBullet.tscn")

export var direction = Vector2.ZERO
export(String) var target = "enemy"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func fire():
	var bullet
	if(target == "player"):
		bullet = EnemyBullet.instance()
	else:
		bullet = Bullet.instance()
	bullet.direction = direction
	get_node("../..").add_child(bullet)
	bullet.global_position = global_position
	$FireAudio.play()
