extends Node2D

const PROJECTILE = preload("res://prefab/StoneGolemProjectile.tscn")

onready var projectileLaunchPosition = $KinematicBody2D/ProjectilePosition

var heldItem = null
var target = null
var direction = Vector2.ZERO
var health = 10

func spawnRock(body = null):
	if body != null:
		target = body
	if $KinematicBody2D/shotTimer.is_stopped():
		$KinematicBody2D/shotTimer.start()
	if heldItem == null:
		heldItem = PROJECTILE.instance()
		projectileLaunchPosition.add_child(heldItem)
		throwHeldItem(target)
		
func throwHeldItem(body):
	heldItem.launch(body.position)
	heldItem = null

func damage(damage):
	#take damage
	print("golem take damage")
	health -= damage[0]
	if health <= 0:
		queue_free()

# warning-ignore:unused_argument
func _on_ActivationArea_body_exited(body):
	$KinematicBody2D/shotTimer.stop()
	target = null
