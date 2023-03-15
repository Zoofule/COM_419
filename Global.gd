extends Node
#Global script

var playerHealth = 10
var hasGrapple = false
var hasMech = false

var currentScene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	#identify the current scene
	#the current scene will be the last thing loaded by root
	var root = get_tree().root
	currentScene = root.get_child(root.get_child_count() - 1) 



