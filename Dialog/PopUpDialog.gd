extends Control

var dialog = [
	"This is the first bit. Idk what to say here...",
	"This is the second bit. OK.",
	"Something else again."
]

var dialog_index = 0
var finished = false
onready var labelText = get_node("ColorRect/Label")

func _ready():
	pass

func start():
	visible = true
	load_dialog()

func load_dialog():
	if dialog_index < dialog.size():
		labelText.visible_characters = 0
		finished = false
		labelText.bbcode_text = dialog[dialog_index]
		$TextTimer.start()
	else:
		queue_free()
	dialog_index += 1

func _on_Timer_timeout():
	load_dialog()


func _on_TextTimer_timeout():
	labelText.visible_characters += 1
	if(labelText.visible_characters >= labelText.text.length()):
		finished = true
		$Timer.start()
		$TextTimer.stop()
