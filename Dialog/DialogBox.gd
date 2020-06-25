extends Control

export(Array, String) var dialog

var dialog_index = 0
var finished = false

signal dialogFinished

func _ready():
	load_dialog()
	
func _process(delta):
	$Icon.visible = finished
	if Input.is_action_just_pressed("dialog"):
		if finished:
			load_dialog()
		else:
			$TextTimer.stop()
			$Label.visible_characters = $Label.text.length()
			finished = true
			
	
func load_dialog():
	if dialog_index < dialog.size():
		$Label.visible_characters = 0
		finished = false
		$Label.bbcode_text = dialog[dialog_index]
		$TextTimer.start()
	else:
		emit_signal("dialogFinished")
		queue_free()
	dialog_index += 1


func _on_TextTimer_timeout():
	$Label.visible_characters += 1
	if($Label.visible_characters >= $Label.text.length()):
		finished = true
		$TextTimer.stop()



