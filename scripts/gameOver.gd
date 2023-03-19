extends Control



func _on_PlayAgain_pressed():
	Global.emit_signal("returnToMainMenu")


func _on_Quit_pressed():
	get_tree().quit()
