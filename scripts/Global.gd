extends Node
#Global script

const SAVE_PATH = "user://save_data.json"

signal updateHealth(newHealth)
signal updateMaxHealth(maxHealth)
signal updateCharge(newCharge)
signal updateMaxCharge(newCharge)
signal returnToMainMenu()
signal deathScreen()
signal groundedUpdate(isGrounded)
signal startGrappleCooldown()
signal loadSave()
signal startHoverTimer()

var mainScene
var curLife = [10, 10] #human, mech
var maxLife = [10, 10]
var gravity = 10
var hasGrapple = true
var hasMech = true
var mechState = 0
var updateSignals = ["updateHealth", "updateCharge"]
var updateMaxSignals = ["updateMaxHealth", "updateMaxCharge"]
var canLoad = false
var currentScene = null
var flying = false #grappling hook flying
var hooked = false #grappling hook hooked
var isHovering = false #mech hovering
var canHover = true
var holdingObject = null
var releaseGrapple = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#identify the current scene
	#the current scene will be the last thing loaded by root
	var root = get_tree().root
	currentScene = root.get_child(root.get_child_count() - 1) 
	var file = File.new()
	if file.file_exists(SAVE_PATH):
		canLoad = true
	file.close()
	
	
func UpdateHealth(value, state = mechState):
	value = min(value, maxLife[state])
	curLife[state] = value
	emit_signal(updateSignals[state], value)
func UpdateMaxHealth(value, state = mechState):
	maxLife[state] = value
	emit_signal(updateMaxSignals[state], value)
func saveData(path : String):
	var currentData = {
		"curLife" : curLife,
		"maxLife" : maxLife,
		"hasGrapple" : hasGrapple,
		"hasMech" : hasMech,
		"currentScene" : currentScene
	}
	var file
	file = File.new()
	file.open(path, File.WRITE)
	file.store_line(to_json(currentData))
	file.close()
func loadData(path : String):
	var file = File.new()
	file.open(path, File.READ)
	var jsonData = parse_json(file.get_as_text())
	file.close()
	curLife = jsonData.curLife
	maxLife = jsonData.maxLife
	hasGrapple = jsonData.hasGrapple
	hasMech = jsonData.hasMech
	currentScene = jsonData.currentScene
	emit_signal("loadSave")
	




