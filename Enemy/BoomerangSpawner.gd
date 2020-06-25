extends Node2D

const Boomerang = preload("res://Enemy/Boomerang.tscn")

export var direction = Vector2.ZERO

func _ready():
	pass


func fire():
	var boomerang = Boomerang.instance()
	boomerang.direction = direction
	get_node("../..").add_child(boomerang)
	boomerang.global_position = global_position
	$FireAudio.play()
