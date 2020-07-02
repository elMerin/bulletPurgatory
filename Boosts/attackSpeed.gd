extends Area2D



func _ready():
	$AnimationPlayer.play("fadeIn")

func _on_attackSpeedBoost_area_entered(area):
	area.get_parent().attackSpeedBoost()
	get_tree().current_scene.get_node("Sounds/attackSpeed").play()
	queue_free()
