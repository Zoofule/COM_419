extends Area2D

export var amount = 1

func _on_HealthPickup_area_entered(area):
	Global.UpdateHealth(Global.curLife[1] + amount, 1)
	queue_free()
