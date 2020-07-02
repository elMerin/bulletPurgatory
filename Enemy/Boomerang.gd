extends KinematicBody2D


var direction = Vector2.ZERO
var velocity = Vector2.ZERO
var goal = Vector2.ZERO
var state = TRAVELING

enum{
	TRAVELING, RETURNING
}

# Called when the node enters the scene tree for the first time.
func _ready():
	$fireBoomerang.play()
	velocity = direction
	goal = Vector2(0,global_position.y+800)

func _physics_process(delta):
#	check this on way back
#		if !get_node("Vis").is_on_screen():
#			queue_free()
	if(global_position.y > goal.y):
		state = RETURNING
	if(state == TRAVELING):	
		velocity = velocity.move_toward(Vector2.ZERO, 100*delta)
	else:
		velocity = velocity.move_toward(-direction, 500*delta)
		if(global_position.y<=-100):
			queue_free()
	move_and_slide(velocity)


func _on_Hitbox_area_entered(area):
	PlayerStats.health -= $Hitbox.damage
	get_tree().current_scene.get_node("Sounds/hit").play()
