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

var currentStage = stage5
var stage5Over = false	
var reloaded = false

func _ready():
	#$endDialog.start()
	if !reloaded:
		$BeforeSpawn.start()
	else:
		stageTimerFinished()		
	print("This is level 3")
	
	
func _on_BeforeSpawn_timeout():
	var dialog = PopDialog.instance()
	dialog.dialog = ["Looks like there are more on the way..."]
	dialog.set_anchors_and_margins_preset(Control.PRESET_CENTER_BOTTOM, Control.PRESET_MODE_KEEP_SIZE)
	$CanvasLayer.add_child(dialog)
	dialog.start()
	$Spawner.start()

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
		$endDialog.start()

func startStageTimer(seconds):
	$stageTimer.wait_time = seconds
	$stageTimer.connect("timeout",self,"stageTimerFinished",[],CONNECT_ONESHOT)
	$stageTimer.start()

func stageTimerFinished():
	match currentStage:
		stage1:
			var boomer = Boomer.instance()
			boomer.position = Vector2(500,-100)
			boomer.connect("noHealth", self, "firstKilled")
			boomer.get_node("activeTimer").wait_time = 3
			var dialog = PopDialog.instance()
			dialog.dialog = ["[wave amp=50 freq=4]Heyyy theeere[/wave]"]
			dialog.get_node("Timer").wait_time = 3
			dialog.set_anchors_and_margins_preset(Control.PRESET_TOP_RIGHT, Control.PRESET_MODE_KEEP_SIZE)
			boomer.get_node("Dialog").add_child(dialog)
			call_deferred("add_child",boomer)
		stage2:
			var boomer = Boomer.instance()
			boomer.position = Vector2(600,-100)
			boomer.connect("noHealth", self, "secondKilled")
			call_deferred("add_child",boomer)
			var diver = Diver.instance()
			diver.position = Vector2(400,-100)
			diver.connect("noHealth", self, "secondKilled")
			diver.connect("diverFell", self, "secondKilled")
			call_deferred("add_child",diver)
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
			var boomer = Boomer.instance()
			boomer.position = Vector2(300,-100)
			boomer.connect("noHealth", self, "thirdKilled")
			call_deferred("add_child",boomer)
		stage4:
			var diver = Diver.instance()
			diver.position = Vector2(100,-100)
			diver.connect("noHealth", self, "fourthKilled")
			diver.connect("diverFell", self, "fourthKilled")
			call_deferred("add_child",diver)
			var boomer = Boomer.instance()
			boomer.position = Vector2(900,-100)
			boomer.connect("noHealth", self, "fourthKilled")
			call_deferred("add_child",boomer)
			var shooter = Shooter.instance()
			shooter.position = Vector2(700,-100)
			shooter.fireSpeed = 1
			shooter.MAX_SPEED = 1000
			shooter.connect("noHealth", self, "fourthKilled")
			call_deferred("add_child",shooter)
			var boomer2 = Boomer.instance()
			boomer2.position = Vector2(300,-100)
			boomer2.connect("noHealth", self, "fourthKilled")
			call_deferred("add_child",boomer2)
		stage5:
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
	
	if iteration%2 == 0:
		var shooter = Shooter.instance()
		shooter.position = Vector2(randi()%1000,-100)
		shooter.MAX_SPEED = 750
		shooter.ACCELERATION = 750
		shooter.fireSpeed = rand_range(1.3,1.7)
		shooter.connect("noHealth", self, "fifthKilled")
		call_deferred("add_child",shooter)
	elif iteration%3 == 0:
		var boomer = Boomer.instance()
		boomer.position = Vector2(randi()%900+100,-100)
		boomer.connect("noHealth", self, "fifthKilled")
		call_deferred("add_child",boomer)
	else:
		var diver = Diver.instance()
		diver.position = Vector2(randi()%1000,-100)
		diver.MAX_SPEED = 750
		diver.ACCELERATION = 750
		diver.connect("noHealth", self, "fifthKilled")
		diver.connect("diverFell", self, "fifthKilled")
		call_deferred("add_child",diver)
	
	if iteration%5 == 0:
		var healthBoost = HealthBoost.instance()
		healthBoost.position = Vector2(randi()%900+100,680)
		call_deferred("add_child",healthBoost)
		
	if iteration == 15:
		var speedBoost = SpeedBoost.instance()
		speedBoost.position = Vector2(800,680)
		call_deferred("add_child",speedBoost)
	
	if iteration == 20:
		var quickFire = QuickFire.instance()
		quickFire.position = Vector2(800,680)
		call_deferred("add_child",quickFire)
		$stage5Timer.wait_time -= 0.5
	
	if stage5Over:
		$stage5Timer.stop()

func _on_stage5Length_timeout():
	stage5Over = true
	


func _on_endOfLevel_timeout():
	queue_free()

func _on_endDialog_timeout():
	var dialog = Dialog.instance()
	dialog.dialog = ["You hear laughter in the distance, slowly coming closer."]
	dialog.connect("dialogFinished", self, "onDialogFinished")
	$CanvasLayer.add_child(dialog)
	
func onDialogFinished():
	$AnimationPlayer.play("showFace")
	
func animFinished():
	var dialog = Dialog.instance()
	dialog.dialog = ["It speaks:\n[color=#FF00FF]It was fun playing with you guys. Go on your way, I won't bother you anymore.[/color]"]
	dialog.connect("dialogFinished", self, "onDialogFinished2")
	$CanvasLayer.add_child(dialog)
	
func onDialogFinished2():
	$AnimationPlayer.play("hideFace")
	
func faceHidden():
	$AnimationPlayer.play("end")
	
func theEnd():
	emit_signal("loadLevel", "level1")

	

