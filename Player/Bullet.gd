extends KinematicBody2D

var direction = Vector2.ZERO
var targetHit = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().current_scene.get_node("Sounds/playerFire").play()

func _physics_process(delta):
	if !get_node("Vis").is_on_screen():
		queue_free()
	move_and_slide(direction)


func _on_Hitbox_area_entered(area):
	if !targetHit:
		targetHit = true
		area.get_node("../Stats").health -= $Hitbox.damage
		get_tree().current_scene.get_node("Sounds/hit").play()
		queue_free()
