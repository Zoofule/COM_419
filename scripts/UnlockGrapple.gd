extends Node2D

func _on_Area2D_body_entered(body):
	Global.hasGrapple = true
	queue_free()
