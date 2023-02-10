extends KinematicBody2D

var velocity = Vector2()
var walkSpeed = 30
var runSpeed = 45
var playerSpeed = 0
var onGround = false

const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0,-1)


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
	#Move Player
	velocity = move_and_slide(velocity, FLOOR)
	
