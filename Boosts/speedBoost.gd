extends Area2D


func _ready():
	$AnimationPlayer.play("fadeIn")


func _on_speedBoost_area_entered(area):
	area.get_parent().speedBoost()
	get_tree().current_scene.get_node("Sounds/speedBoost").play()
	queue_free()
