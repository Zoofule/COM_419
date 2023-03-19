extends KinematicBody2D

signal attack(damage)

const GRAVITY = 10
const SPEED = 50
const FLOOR = Vector2(0,-1)

var velocity = Vector2()
var direction = 1 #1 for right, -1 for left
var health = 15



func _physics_process(delta):
	if direction == 1:
		get_node( "Sprite" ).set_flip_h( false )
	else:
		get_node( "Sprite" ).set_flip_h( true )
	velocity.x = SPEED * direction
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)
	
	if is_on_wall():
		direction *= -1
		$RayCast2D.position.x *= -1
		$DamageArea/CollisionShape2D.position.x *= -1
	elif $RayCast2D.is_colliding() == false:
		direction *= -1
		$RayCast2D.position.x *= -1
		$DamageArea/CollisionShape2D.position.x *= -1
		
func damage(damage):
	health -= damage[0]
	if health <= 0:
		queue_free()
	
	


func _on_HealArea_area_entered(area):
	if area.entity is PlantEnemy:
		health += 1
		$AnimationPlayer.play("WolfHeal")


func _on_HealArea_area_exited(area):
	if area.entity is PlantEnemy:
		$AnimationPlayer.stop()
