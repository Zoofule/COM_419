extends Node2D
#script for things that apply to both the regular character and mech
#i.e death pit

var globalVar = null

	
func _on_Enemy_dead():
	Global.playerHealth -= 3
	queue_free()
	get_tree().change_scene("res://GameOver.tscn")


func _on_deathPit_body_entered(body):
	queue_free()
	get_tree().change_scene("res://GameOver.tscn")


func _next_level_entered(body):
	Global.emit_signal("updateLevel", "MainScene")
