extends KinematicBody2D
class_name MovableBlock
signal releaseGrapple()


var velocity = Vector2.ZERO

func _physics_process(delta):
	velocity.y += Global.gravity
	move_and_slide(velocity)
		

func set_velocity(vel):
	velocity = vel


func _on_stopMovement_body_entered(body):
	Global.holdingObject = null
	body.releaseGrapple()
	velocity = Vector2.ZERO
	



