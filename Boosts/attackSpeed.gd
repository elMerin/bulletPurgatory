extends Area2D



func _ready():
	$AnimationPlayer.play("fadeIn")

func _on_attackSpeedBoost_area_entered(area):
	area.get_parent().attackSpeedBoost()
	queue_free()
