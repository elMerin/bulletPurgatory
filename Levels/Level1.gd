extends Node2D

const Shooter = preload("res://Enemy/Shooter.tscn")
const Diver = preload("res://Enemy/Diver.tscn")
const Boomer = preload("res://Enemy/Boomer.tscn")
const Dialog = preload("res://Dialog/Dialog.tscn")
const PopDialog = preload("res://Dialog/PopUpDialog.tscn")
const HealthBoost = preload("res://Boosts/healthBoost.tscn")
const QuickFire = preload("res://Boosts/quickFire.tscn")
const AttackSpeed = preload("res://Boosts/attackSpeed.tscn")

enum{
	stage1,
	stage2,
	stage3,
	stage4,
	stage5
}

signal loadLevel

var currentStage = stage1
var stage5Over = false	
var reloaded = false

func _ready():
	if !reloaded:
		$CanvasLayer/DialogBox.connect("dialogFinished", self, "onDialogFinished")
	else:
		$CanvasLayer/DialogBox.queue_free()
		stageTimerFinished()
	print("This is level 1")
	

func onDialogFinished():
	$BeforeSpawn.start()
	
func _on_BeforeSpawn_timeout():
#	var dialog = PopDialog.instance()
#	dialog.dialog = ["Watch out! Something's coming..."]
#	dialog.set_anchors_and_margins_preset(Control.PRESET_CENTER_BOTTOM, Control.PRESET_MODE_KEEP_SIZE)
#	$CanvasLayer.add_child(dialog)
#	dialog.start()
#	$Spawner.start()
	_on_Spawner_timeout()

func _on_Spawner_timeout():
	stageTimerFinished()
	
func firstKilled():
	currentStage = stage2
	startStageTimer(2)
	
func secondKilled():
	currentStage = stage3
	startStageTimer(2)

func thirdKilled():
	if get_tree().get_nodes_in_group("Enemy").size()<=1:
		currentStage = stage4
		startStageTimer(2)
		
func fourthKilled():
	if get_tree().get_nodes_in_group("Enemy").size()<=1:
		currentStage = stage5
		startStageTimer(2)
		var healthBoost = HealthBoost.instance()
		healthBoost.position = Vector2(800,680)
		call_deferred("add_child",healthBoost)
		
func fifthKilled():
	if get_tree().get_nodes_in_group("Enemy").size()<=1 && stage5Over:
		$endOfLevel.start()
		var dialog = PopDialog.instance()
		dialog.dialog = ["The massacre seems to be at an end... for now.","I still feel drawn forward. I need to proceed."]
		dialog.set_anchors_and_margins_preset(Control.PRESET_CENTER_BOTTOM, Control.PRESET_MODE_KEEP_SIZE)
		$CanvasLayer.add_child(dialog)
		dialog.start()

func startStageTimer(seconds):
	$stageTimer.wait_time = seconds
	$stageTimer.connect("timeout",self,"stageTimerFinished",[],CONNECT_ONESHOT)
	$stageTimer.start()

func stageTimerFinished():
	match currentStage:
		stage1:
			var shooter = Shooter.instance()
			shooter.position = Vector2(500,-100)
			shooter.fireSpeed = 0.5
			shooter.connect("noHealth", self, "firstKilled")
			shooter.get_node("activeTimer").wait_time = 6
			var dialog = PopDialog.instance()
			dialog.dialog = ["Where do you think you're going?","Well, I can't let anyone pass."]
			dialog.set_anchors_and_margins_preset(Control.PRESET_TOP_RIGHT, Control.PRESET_MODE_KEEP_SIZE)
			shooter.get_node("Dialog").add_child(dialog)
			call_deferred("add_child",shooter)
		stage2:
			var shooter = Shooter.instance()
			shooter.position = Vector2(500,-100)
			shooter.MAX_SPEED = 750
			shooter.fireSpeed = 1
			shooter.connect("noHealth", self, "secondKilled")
			var dialog = PopDialog.instance()
			shooter.get_node("activeTimer").wait_time = 3
			dialog.dialog = ["[shake rate=10 level=10]OH GOD[/shake] YOU KILLED BILLY"]
			dialog.set_anchors_and_margins_preset(Control.PRESET_TOP_RIGHT, Control.PRESET_MODE_KEEP_SIZE)
			shooter.get_node("Dialog").add_child(dialog)
			call_deferred("add_child",shooter)
		stage3:
			var shooter = Shooter.instance()
			shooter.position = Vector2(200,-100)
			shooter.fireSpeed = 1
			shooter.MAX_SPEED = 1000
			shooter.connect("noHealth", self, "thirdKilled")
			call_deferred("add_child",shooter)
			var shooter2 = Shooter.instance()
			shooter2.position = Vector2(800,-100)
			shooter2.fireSpeed = 1
			shooter2.connect("noHealth", self, "thirdKilled")
			call_deferred("add_child",shooter2)
		stage4:
			var shooter = Shooter.instance()
			shooter.position = Vector2(200,-100)
			shooter.fireSpeed = 1.5
			shooter.MAX_SPEED = 1000
			shooter.connect("noHealth", self, "fourthKilled")
			call_deferred("add_child",shooter)
			var shooter2 = Shooter.instance()
			shooter2.position = Vector2(500,-100)
			shooter2.fireSpeed = 1.0
			shooter2.MAX_SPEED = 2000
			shooter2.connect("noHealth", self, "fourthKilled")
			call_deferred("add_child",shooter2)
			var shooter3 = Shooter.instance()
			shooter3.position = Vector2(800,-100)
			shooter3.MAX_SPEED = 500
			shooter3.fireSpeed = 2
			shooter3.connect("noHealth", self, "fourthKilled")
			call_deferred("add_child",shooter3)
		stage5:
#			var dialog = PopDialog.instance()
#			dialog.dialog = ["They're going to be coming more frequently now..."]
#			dialog.set_anchors_and_margins_preset(Control.PRESET_CENTER_BOTTOM, Control.PRESET_MODE_KEEP_SIZE)
#			dialog.get_node("Timer").connect("timeout",self,"stage5Start")
#			$CanvasLayer.add_child(dialog)
#			dialog.start()
			stage5Start()

func stage5Start():
	$stage5Length.start()
	var shooter = Shooter.instance()
	shooter.position = Vector2(randi()%1000,-100)
	shooter.MAX_SPEED = 750
	shooter.ACCELERATION = 750
	shooter.fireSpeed = rand_range(1.3,1.7)
	shooter.connect("noHealth", self, "fifthKilled")
	call_deferred("add_child",shooter)
	$stage5Timer.start()


func _on_stage5Timer_timeout():
	var shooter = Shooter.instance()
	shooter.position = Vector2(randi()%1000,-100)
	shooter.MAX_SPEED = 750
	shooter.ACCELERATION = 750
	shooter.fireSpeed = rand_range(1.3,1.7)
	shooter.connect("noHealth", self, "fifthKilled")
	call_deferred("add_child",shooter)
	if stage5Over:
		$stage5Timer.stop()

func _on_stage5Length_timeout():
	stage5Over = true
	


func _on_endOfLevel_timeout():
		emit_signal("loadLevel", "level2")
