extends Control

onready var HUD : Control = $HUD
onready var menu : Control = $Menu
onready var main2D : Node2D = $Main2D
onready var camera : Camera2D = $Main2D/Camera2D
var levelInstance

func _ready():
	Global.mainScene = self
	Global.connect("updateLevel", self, "loadLevel")
	Global.connect("updateHealth", $HUD/HUD/CanvasLayer/HealthBar, "UpdateHealth")
	Global.connect("updateMaxHealth", $HUD/HUD/CanvasLayer/HealthBar, "UpdateMaxHealth")
	
func unloadLevel():
	if (is_instance_valid(levelInstance)):
		levelInstance.queue_free()
	levelInstance = null
func loadLevel(levelName : String):
	unloadLevel()
	var levelPath := "res://Levels/%s.tscn" % levelName
	var levelResource := load(levelPath)
	if (levelResource):
		levelInstance = levelResource.instance()
		main2D.add_child(levelInstance)
	


func _on_Button_pressed():
	loadLevel("StageOne")
	#initialize health bar
	$HUD/HUD/CanvasLayer/HealthBar.show()
	Global.emit_signal("updateMaxHealth", Global.playerHealth)
	Global.emit_signal("updateHealth", Global.playerHealth)
	menu.hide()
	
