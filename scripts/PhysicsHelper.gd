extends Node
class_name PhysicsHelper


static func calculateArcVelocity(pointA, pointB, arcHeight, upGravity = Global.gravity, downGravity = null):
	if downGravity == null:
		downGravity = upGravity
	var velocity = Vector2.ZERO
	var displacement = pointB - pointA
	var timeUp = sqrt(-2 * arcHeight / float(upGravity))
	var timeDown = sqrt(2 * (displacement.y - arcHeight) / float(downGravity))
	if is_nan(timeDown):
		timeDown = 0
	var airTime = float(timeUp+timeDown)
	velocity.y = -sqrt(-2 * upGravity * arcHeight)
	velocity.x = displacement.x / airTime
	return velocity
