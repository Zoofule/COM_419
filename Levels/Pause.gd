extends Control

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		var pauseState = not get_tree().paused
		get_tree().paused = pauseState
		visible = pauseState


func _on_resume_pressed():
	get_tree().paused = false
	visible = false


func _on_quit_pressed():
	get_tree().quit()
