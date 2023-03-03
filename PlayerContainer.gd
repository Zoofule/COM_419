extends Node2D
#script for things that apply to both the regular character and mech
#i.e death pit

var globalVar = null

func _ready():
	globalVar = get_node("/root/Global")
	
func _on_Enemy_dead():
	globalVar.playerHealth -= 3
	queue_free()
	get_tree().change_scene("res://GameOver.tscn")


func _on_deathPit_body_entered(body):
	queue_free()
	get_tree().change_scene("res://GameOver.tscn")
