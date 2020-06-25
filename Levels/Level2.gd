extends Node2D

const Shooter = preload("res://Enemy/Shooter.tscn")
const Diver = preload("res://Enemy/Diver.tscn")
const Boomer = preload("res://Enemy/Boomer.tscn")
const Dialog = preload("res://Dialog/Dialog.tscn")
const PopDialog = preload("res://Dialog/PopUpDialog.tscn")
const HealthBoost = preload("res://Boosts/healthBoost.tscn")
const QuickFire = preload("res://Boosts/quickFire.tscn")
const AttackSpeed = preload("res://Boosts/attackSpeed.tscn")
const SpeedBoost = preload("res://Boosts/speedBoost.tscn")

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
#	if !reloaded:
#		$BeforeSpawn.start()
#	else:
	stageTimerFinished()
	print("This is level 2")
	
	
func _on_BeforeSpawn_timeout():
	pass
#	var dialog = PopDialog.instance()
#	dialog.dialog = ["More shapes are coming"]
#	dialog.set_anchors_and_margins_preset(Control.PRESET_CENTER_BOTTOM, Control.PRESET_MODE_KEEP_SIZE)
#	$CanvasLayer.add_child(dialog)
#	dialog.start()
#	$Spawner.start()

func _on_Spawner_timeout():
	stageTimerFinished()
	
func firstKilled():
	currentStage = stage2
	startStageTimer(2)
	
func secondKilled():
	if get_tree().get_nodes_in_group("Enemy").size()<=1:
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
		healthBoost.position = Vector2(400,680)
		call_deferred("add_child",healthBoost)
		
func fifthKilled():
	if get_tree().get_nodes_in_group("Enemy").size()<=1 && stage5Over:
		$endOfLevel.start()
		var dialog = PopDialog.instance()
		dialog.dialog = ["They don't seem to know what they're doing either.","It's like we're being controlled by something."]
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
			var diver = Diver.instance()
			diver.position = Vector2(500,-100)
			diver.connect("noHealth", self, "firstKilled")
			diver.connect("diverFell", self, "firstKilled")
			diver.get_node("activeTimer").wait_time = 6
			var dialog = PopDialog.instance()
			dialog.dialog = ["Don't really know why I'm doing this...","but you've killed so many of us already"]
			dialog.set_anchors_and_margins_preset(Control.PRESET_TOP_RIGHT, Control.PRESET_MODE_KEEP_SIZE)
			diver.get_node("Dialog").add_child(dialog)
			call_deferred("add_child",diver)
		stage2:
			var diver = Diver.instance()
			diver.position = Vector2(400,-100)
			diver.connect("noHealth", self, "secondKilled")
			diver.connect("diverFell", self, "secondKilled")
			call_deferred("add_child",diver)
			var shooter = Shooter.instance()
			shooter.position = Vector2(600,-100)
			shooter.fireSpeed = 1
			shooter.MAX_SPEED = 1000
			shooter.connect("noHealth", self, "secondKilled")
			call_deferred("add_child",shooter)
		stage3:
			var diver = Diver.instance()
			diver.position = Vector2(500,-100)
			diver.connect("noHealth", self, "thirdKilled")
			diver.connect("diverFell", self, "thirdKilled")
			call_deferred("add_child",diver)
			var shooter = Shooter.instance()
			shooter.position = Vector2(700,-100)
			shooter.fireSpeed = 1
			shooter.MAX_SPEED = 1000
			shooter.connect("noHealth", self, "thirdKilled")
			call_deferred("add_child",shooter)
			var shooter2 = Shooter.instance()
			shooter2.position = Vector2(300,-100)
			shooter2.fireSpeed = 1
			shooter2.MAX_SPEED = 1000
			shooter2.connect("noHealth", self, "thirdKilled")
			call_deferred("add_child",shooter2)
		stage4:
			var diver = Diver.instance()
			diver.position = Vector2(100,-100)
			diver.connect("noHealth", self, "fourthKilled")
			diver.connect("diverFell", self, "fourthKilled")
			call_deferred("add_child",diver)
			var diver2 = Diver.instance()
			diver2.position = Vector2(900,-100)
			diver2.connect("noHealth", self, "fourthKilled")
			diver2.connect("diverFell", self, "fourthKilled")
			call_deferred("add_child",diver2)
			var shooter = Shooter.instance()
			shooter.position = Vector2(700,-100)
			shooter.fireSpeed = 1
			shooter.MAX_SPEED = 1000
			shooter.connect("noHealth", self, "fourthKilled")
			call_deferred("add_child",shooter)
			var shooter2 = Shooter.instance()
			shooter2.position = Vector2(300,-100)
			shooter2.fireSpeed = 1.5
			shooter2.MAX_SPEED = 1000
			shooter2.connect("noHealth", self, "fourthKilled")
			call_deferred("add_child",shooter2)
		stage5:
			var speedBoost = SpeedBoost.instance()
			speedBoost.position = Vector2(800,680)
			call_deferred("add_child",speedBoost)
			stage5Start()
			#var dialog = PopDialog.instance()
			#dialog.dialog = ["They're going to be coming more frequently now..."]
			#dialog.set_anchors_and_margins_preset(Control.PRESET_CENTER_BOTTOM, Control.PRESET_MODE_KEEP_SIZE)
			#dialog.get_node("Timer").connect("timeout",self,"stage5Start")
			#$CanvasLayer.add_child(dialog)
			#dialog.start()

var iteration = 0

func stage5Start():
	$stage5Length.start()
	iteration = 1
	var diver = Diver.instance()
	diver.position = Vector2(randi()%1000,-100)
	diver.MAX_SPEED = 750
	diver.ACCELERATION = 750
	diver.connect("noHealth", self, "fifthKilled")
	diver.connect("diverFell", self, "fifthKilled")
	call_deferred("add_child",diver)
	$stage5Timer.start()


func _on_stage5Timer_timeout():
	iteration+=1
	
	if iteration == 10:
		$stage5Timer.wait_time -= 0.5
	
	if iteration%2 == 0:
		var shooter = Shooter.instance()
		shooter.position = Vector2(randi()%1000,-100)
		shooter.MAX_SPEED = 750
		shooter.ACCELERATION = 750
		shooter.fireSpeed = rand_range(1.3,1.7)
		shooter.connect("noHealth", self, "fifthKilled")
		call_deferred("add_child",shooter)
	else:
		var diver = Diver.instance()
		diver.position = Vector2(randi()%1000,-100)
		diver.MAX_SPEED = 750
		diver.ACCELERATION = 750
		diver.connect("noHealth", self, "fifthKilled")
		diver.connect("diverFell", self, "fifthKilled")
		call_deferred("add_child",diver)
	if stage5Over:
		$stage5Timer.stop()

func _on_stage5Length_timeout():
	stage5Over = true
	
func _on_endOfLevel_timeout():
		emit_signal("loadLevel", "level3")
