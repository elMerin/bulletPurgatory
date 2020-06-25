extends Area2D


func _ready():
	$AnimationPlayer.play("fadeIn")


func _on_speedBoost_area_entered(area):
	area.get_parent().speedBoost()
	queue_free()
