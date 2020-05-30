extends Node2D

const Bullet = preload("res://Player/Bullet.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func fire():
	var bullet = Bullet.instance()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position
