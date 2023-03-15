extends Node2D


var globalVars = null
func _ready():
	globalVars = get_node("/root/Global")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	globalVars.hasGrapple = true
	queue_free()
