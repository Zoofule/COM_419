extends Control



func _on_PlayAgain_pressed():
	get_tree().change_scene("res://StageOne.tscn")


func _on_Quit_pressed():
	get_tree().quit()
