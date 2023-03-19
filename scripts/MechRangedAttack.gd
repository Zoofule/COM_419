extends Node2D
const SPEED = 100
var velocity = Vector2.ZERO
var direction = 1

func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)

func _set_direction(dir):
	direction = dir
	if dir == -1:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false

func delete(_area = null):
	queue_free()

