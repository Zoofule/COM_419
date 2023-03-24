extends Node2D
#script for things that apply to both the regular character and mech
#i.e death pit

var globalVar = null

	
func _on_Enemy_dead():
	Global.playerHealth -= 3
	queue_free()
	Global.emit_signal("deathScreen")


func _on_deathPit_body_entered(body):
	queue_free()
	Global.emit_signal("deathScreen")


func _next_level_entered(body):
	Global.emit_signal("returnToMainMenu")
