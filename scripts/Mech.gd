extends KinematicBody2D


var velocity = Vector2()
var chainVelocity := Vector2(0,0)
var playerSpeed = 45
var onGround = false






const GRAVITY = 10
const JUMP_POWER = -350
const FLOOR = Vector2(0,-1)



func _physics_process(delta):
	var playerScene = load("res://prefab/player.tscn")
	
	if Input.is_action_pressed("ui_"):
		Global.inMech = false
		$CollisionShape2D.disabled = true
		self.hide()
		var new_player = playerScene.instance()
		new_player.global_position = self.global_position
		get_parent().add_child(new_player)
		queue_free()
	
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
	if Input.is_action_pressed("ui_select"):
		if onGround:
			velocity.y = JUMP_POWER
			onGround = false
		else:
			velocity.y = -GRAVITY+3
	#gravity
	velocity.y += GRAVITY
	if is_on_floor():
		onGround = true
	velocity = move_and_slide(velocity, FLOOR)
		
	
	
	
