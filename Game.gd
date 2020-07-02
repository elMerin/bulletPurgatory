extends Node

const Level1 = preload("res://Levels/Level1.tscn")
const Level2 = preload("res://Levels/Level2.tscn")
const Level3 = preload("res://Levels/Level3.tscn")
const saveName = "user://saveData.json"

var saveInfo = {
	"level": "level1"
}

func _ready():
	randomize()
	#loadData()
	loadLevel(saveInfo.level, false)
	$AnimationPlayer.play("fadeIn")

#func loadData():
#	var file = File.new()
#	if file.file_exists(saveName):
#		file.open(saveName, File.READ)
#		var data = parse_json(file.get_as_text())
#		file.close()
#		if typeof(data) == TYPE_DICTIONARY:
#			saveInfo = data
#		else:
#			printerr("Corrupted data!")
#	else:
#		pass
		
func loadLevel(levelString, reloaded):
	if(levelString == "level1"):
		var level = Level1.instance()
		level.reloaded = reloaded
		level.connect("loadLevel",self,"levelFinished",[],CONNECT_ONESHOT)
		$currentLevel.add_child(level)
	elif(levelString == "level2"):
		var level = Level2.instance()
		level.reloaded = reloaded
		level.connect("loadLevel",self,"levelFinished",[],CONNECT_ONESHOT)
		$currentLevel.add_child(level)
	elif(levelString == "level3"):
		var level = Level3.instance()
		level.reloaded = reloaded
		level.connect("loadLevel",self,"levelFinished",[],CONNECT_ONESHOT)
		$currentLevel.add_child(level)

func saveData():
	var file = File.new()
	file.open(saveName, File.WRITE)
	file.store_string(to_json(saveInfo))
	file.close()
	
func reload():
	$AnimationPlayer.play("reloadLevel")
	
var nextLevel
func levelFinished(level):
	nextLevel = level
	$AnimationPlayer.play("finishLevel")
	
func reloadFinish():
	for child in $currentLevel.get_children():
		child.queue_free()
	loadLevel(saveInfo.level, true)
	PlayerStats.health = PlayerStats.max_health
	
func finishFinish():
	for child in $currentLevel.get_children():
		child.queue_free()
	loadLevel(nextLevel, false)
	saveInfo.level = nextLevel
	PlayerStats.health = PlayerStats.max_health
	saveData()

