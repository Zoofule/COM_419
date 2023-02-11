extends KinematicBody2D


var velocity = Vector2()
var chainVelocity := Vector2(0,0)
var walkSpeed = 30
var runSpeed = 45
var playerSpeed = 0
var onGround = false
var hookPosition
var currentRopeLength


const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0,-1)
const CHAIN_PULL = 50



func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			# We clicked the mouse -> shoot()
			hookPosition = event.position - get_viewport_rect().size * 0.5
			currentRopeLength = global_position.distance_to(hookPosition)
			$Grapple.shoot(hookPosition)
		else:
			# We released the mouse -> release()
			$Grapple.release()


func _physics_process(delta):
	
	#Run or walk
	if Input.is_action_pressed("Run"):
		playerSpeed = runSpeed
	else:
		playerSpeed = walkSpeed
	#Left and Right
	if Input.is_action_pressed("ui_right"):
		velocity.x = playerSpeed
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -playerSpeed
	else:
		velocity.x = 0
	#Jump
	if Input.is_action_pressed("ui_up"):
		if onGround:
			velocity.y = JUMP_POWER
			onGround = false
	#gravity
	velocity.y += GRAVITY
	if is_on_floor():
		onGround = true
	# Hook physics
	if $Grapple.hooked:
		# `to_local($Chain.tip).normalized()` is the direction that the chain is pulling
		chainVelocity = to_local($Grapple.tip).normalized() * CHAIN_PULL
		velocity = move_and_slide(chainVelocity, FLOOR)
	else:
		# Not hooked -> no chain velocity
		velocity = move_and_slide(velocity, FLOOR)
		
	
	
	
