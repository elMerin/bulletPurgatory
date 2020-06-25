extends KinematicBody2D

var direction = Vector2.ZERO
var targetHit = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if !get_node("Vis").is_on_screen():
		queue_free()
	move_and_slide(direction)


func _on_Hitbox_area_entered(area):
	if !targetHit:
		targetHit = true
		PlayerStats.health -= $Hitbox.damage
		get_tree().current_scene.get_node("Sounds/hit").play()
		queue_free()
