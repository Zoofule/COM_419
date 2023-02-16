extends Node2D
#script for things that apply to both the regular character and mech
#i.e death pit


func _on_Enemy_dead():
	queue_free()
	get_tree().change_scene("res://GameOver.tscn")


func _on_deathPit_body_entered(body):
	queue_free()
	get_tree().change_scene("res://GameOver.tscn")
