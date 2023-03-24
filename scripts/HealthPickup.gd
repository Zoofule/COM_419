extends Area2D

export var amount = 1

func _on_HealthPickup_area_entered(area):
	Global.UpdateHealth(Global.curLife[0] + amount, 0)
	queue_free()
