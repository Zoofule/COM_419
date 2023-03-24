extends KinematicBody2D

signal resetTimer()

var direction = 1
var velocity = Vector2()
var player = null
var stopWalking = false
const FLOOR = Vector2(0,-1)
const SPEED = 30
var minArcHeight = 2

func _physics_process(delta):
	if stopWalking:
		var playerDirection = (player.global_position-global_position).normalized()
		if playerDirection.x > 0:
			direction = 1
			$RayCast2D.position.x = abs($RayCast2D.position.x)
			$ProjectilePosition.position.x = abs($ProjectilePosition.position.x)
		else:
			direction = -1
			$RayCast2D.position.x = -abs($RayCast2D.position.x)
			$ProjectilePosition.position.x = -abs($ProjectilePosition.position.x)
	if direction == 1:
		get_node( "Sprite" ).set_flip_h( true )
	else:
		get_node( "Sprite" ).set_flip_h( false )
	if not stopWalking:
		velocity.x = SPEED * direction
		velocity.y += Global.gravity
		velocity = move_and_slide(velocity, FLOOR)
	
		if is_on_wall():
			direction *= -1
			emit_signal("resetTimer")
			$RayCast2D.position.x *= -1
			$ProjectilePosition.position.x *= -1
		if $RayCast2D.is_colliding() == false:
			direction *= -1
			emit_signal("resetTimer")
			$RayCast2D.position.x *= -1
			$ProjectilePosition.position.x *= -1



func _on_walkTimer_timeout():
	direction *= -1


func _on_ActivationArea_body_entered(body):
	player = body
	stopWalking = true


func _on_ActivationArea_body_exited(body):
	player = null
	stopWalking = false
