extends Camera2D
class_name Camera2d


var facing = 0
var targetNode
var dragging = false
var mouseStartPos
var screenStartPos


func _input(event):
	if event.is_action("mouseMiddle"):
		if event.is_pressed():
			mouseStartPos = event.position
			screenStartPos = position
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		position = zoom * (mouseStartPos - event.position) + screenStartPos
	
		
