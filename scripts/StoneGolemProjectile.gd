extends KinematicBody2D

var velocity = Vector2.ZERO
var localGrav = 100

func _ready():
	set_physics_process(false)
func _physics_process(delta):
	velocity.y += localGrav * delta
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		queue_free()
		

func launch(targetPosition):
	var temp = global_transform
	var scene = get_tree().current_scene
	var kinbody = get_parent().get_parent()
	var minArcHeight = kinbody.minArcHeight
	get_parent().remove_child(self)
	scene.add_child(self)
	global_transform = temp
	
	var arcHeight = targetPosition.y - global_position.y - minArcHeight
	arcHeight = min(arcHeight, -minArcHeight)
	velocity = PhysicsHelper.calculateArcVelocity(global_position, targetPosition, arcHeight, localGrav)
	set_physics_process(true)
	$DamageArea.monitoring = true
	
func _on_DamageArea_area_entered(area):
	queue_free()
