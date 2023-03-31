extends KinematicBody2D
class_name MovableBlock

var velocity = Vector2.ZERO
var isMoving = false

func _physics_process(delta):
	move_and_slide(velocity)
		

func set_velocity(vel):
	velocity = vel


func _on_stopMovement_body_entered(body):
	Global.holdingObject = null
	velocity = Vector2.ZERO
	velocity.y = Global.gravity
	isMoving = false


