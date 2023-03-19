extends Node2D
class_name PlantEnemy
signal startTimer()
signal stopTimer()

var health = 5
var meleeDamage = 3
var target = null
var gasDamage = [1, 0]



func _on_GasArea_area_entered(_area):
	$GasClouds.show()
	emit_signal("startTimer")


func _on_GasArea_area_exited(_area):
	$GasClouds.hide()
	emit_signal("stopTimer")

func damage(damage):
	health -= damage[0]
	if health <= 0:
		death()

func death():
	queue_free()

func _on_Timer_timeout():
	target.damage(gasDamage)

func _on_GasArea_entityDamaged(entity):
	target = entity
