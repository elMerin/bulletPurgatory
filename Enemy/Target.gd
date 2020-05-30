extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Hurtbox_area_entered(area):
	$Stats.health -= area.damage
	get_parent().get_node("hit").play()
	area.get_parent().queue_free()
	


func _on_Stats_no_health():
	get_parent().get_node("die").play()
	queue_free()
