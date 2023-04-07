extends KinematicBody2D


onready var hitbox = $PlayerHitbox
onready var grapple = $Human/Grapple
onready var viewportSize = null
signal stopRechargeTimer()
signal startRechargeTimer()
signal groundedUpdate(isGrounded)

var velocity = Vector2()
var chainVelocity := Vector2(0,0)
var walkSpeed = 125
var runSpeed = 175
var playerSpeed = 0
var isGrounded = false
var wasGrounded = false
var isJumping = false
var hookPosition
var currentRopeLength = 0
var maxRopeLength = 200
var moveDirection = 1
var recharging = false
var facingDirection = 1

const JUMP_POWER = [-250,-300] #human, mech
const FLOOR = Vector2(0,-1)
const CHAIN_PULL = 400
const MECH = preload("res://prefab/Mech.tscn")
const isPlayer = true

func _ready():
	viewportSize = get_viewport_rect().size

func _physics_process(delta):
	#recharge mech
	if Global.mechState == 0 && (Global.curLife[1] != Global.maxLife[1]) && recharging == false:
		recharging = true
		print("recharging")
		emit_signal("startRechargeTimer")
	elif recharging == true && (Global.mechState == 1 || (Global.curLife[1] == Global.maxLife[1])):
		emit_signal("stopRechargeTimer")
		print("stop recharging")
		recharging = false


func damage(damage):
	#take damage
	Global.UpdateHealth(Global.curLife[Global.mechState] - damage[Global.mechState])
	if Global.curLife[1] == 0:
		_toggle_mech()
	if Global.curLife[0] <= 0:
		death()
		
func _apply_movement():
	if isJumping && velocity.y >= 0:
		isJumping = false
	#snap to floor
	var snap = Vector2.DOWN * 32 if !isJumping else Vector2.ZERO
	#Grapple physics and move player
	if Global.mechState == 0 && Global.hooked:
		# `to_local($Chain.tip).normalized()` is the direction that the chain is pulling
		chainVelocity = to_local(grapple.tip).normalized() * CHAIN_PULL
		velocity = move_and_slide(chainVelocity, FLOOR)
	else:
		# Not hooked -> no chain velocity
		velocity = move_and_slide(velocity, FLOOR)
	
	wasGrounded = isGrounded
	isGrounded = is_on_floor()
	
	if wasGrounded == null || wasGrounded != isGrounded:
		Global.emit_signal("groundedUpdate", isGrounded)
func _handle_move_input():
	#Run/walk
	if (Input.is_action_pressed("Run") && Global.mechState == 0) || Global.isHovering:
		playerSpeed = runSpeed
	else:
		playerSpeed = walkSpeed
	velocity.x = moveDirection * playerSpeed
func _apply_gravity(delta):
	if !Global.isHovering:
		velocity.y += Global.gravity
func _update_move_direction():
	moveDirection = -int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right"))
	if moveDirection != 0: facingDirection = moveDirection
	if moveDirection == 1:
		$Human/Sprite.flip_h = false
		$Mech/Sprite.flip_h = false
		if sign($Mech/RangedAttackPos.position.x) != 1:
			$Mech/RangedAttackPos.position.x *= -1
	elif moveDirection == -1:
		$Human/Sprite.flip_h = true
		$Mech/Sprite.flip_h = true
		if sign($Mech/RangedAttackPos.position.x) == 1:
			$Mech/RangedAttackPos.position.x *= -1
 
func _toggle_mech():
	if Global.mechState == 0:
		Global.mechState = 1
		if Global.hooked:
			Global.hooked = false
			Global.hasGrapple = false
			Global.emit_signal("startGrappleCooldown")
		$HumanCollisionShape2D.disabled = true
		$PlayerHitbox/CollisionShape2D.disabled = true
		$MechCollisionShape2D.disabled = false
		$MechHitbox/CollisionShape2D.disabled = false
		$Mech.show()
		$Human.hide()
	else:
		Global.mechState = 0
		Global.isHovering = false
		$HumanCollisionShape2D.disabled = false
		$PlayerHitbox/CollisionShape2D.disabled = false
		$MechCollisionShape2D.disabled = true
		$MechHitbox/CollisionShape2D.disabled = true
		$Mech.hide()
		$Human.show()


func _on_mechRechargeTimer_timeout():
	#recharge mech
	Global.UpdateHealth(Global.curLife[1] + 1, 1)
func death(_area = null):
	Global.emit_signal("deathScreen")
	
func releaseGrapple():
	print("release grapple")
	grapple.release()
	Global.releaseGrapple = false
	Global.emit_signal("startGrappleCooldown")
	Global.hasGrapple = false
	currentRopeLength = 0

