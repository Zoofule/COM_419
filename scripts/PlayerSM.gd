extends "res://scripts/StateMachine.gd"

const FIREBALL = preload("res://prefab/MechRangedAttack.tscn")

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	call_deferred("set_state", states.idle)
	pass
	
	
func _state_logic(delta):
	parent._update_move_direction()
	parent._handle_move_input()
	parent._apply_gravity(delta)
	parent._apply_movement()

func _get_transitions(delta):
	match state:
		states.idle:
			if parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				else:
					return states.fall
			elif parent.velocity.x != 0:
				return states.run
		states.run:
			if parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				else:
					return states.fall
			elif parent.velocity.x == 0:
				return states.idle
		states.jump:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y >= 0:
				return states.fall
		states.fall:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump

func _enter_state(newState, oldState):
	match newState:
		states.idle:
			#idle anim
			pass
		states.run:
			#run anim
			pass
		states.jump:
			#jump anim
			pass
		states.fall:
			#fall anim
			pass

func _exit_state(oldState, newState):
	pass
	
func _input(event) -> void:
	#grappling hook aim
	if event is InputEventMouseButton:
		if event.is_action("leftMouse"):
			if Global.hasGrapple == true && Global.mechState == 0:
				var target = parent.get_global_mouse_position()
				if event.pressed:
					# We clicked the mouse -> shoot()
					#parent.hookPosition = event.position - parent.viewportSize * 0.5
					parent.hookPosition = parent.global_position.direction_to(target)
					parent.currentRopeLength = parent.global_position.distance_to(target)
					if parent.currentRopeLength <= parent.maxRopeLength:
						parent.grapple.shoot(parent.hookPosition)
				else:
					# We released the mouse -> release()
					if Global.hooked || Global.flying:
						parent.grapple.release()
						Global.emit_signal("startGrappleCooldown")
						Global.hasGrapple = false
						parent.currentRopeLength = 0
	#toggle mech mode
	if event.is_action_pressed("toggle") and Global.hasMech == true:
		parent._toggle_mech()
	#Jump
	if event.is_action_pressed("ui_jump"):
		if parent.isGrounded:
			parent.velocity.y = parent.JUMP_POWER[Global.mechState]
			parent.isJumping = true
		elif Global.mechState == 1 && Global.canHover: #mech hover
			parent.velocity.y = 1
			Global.isHovering = true
			Global.emit_signal("startHoverTimer")
			
		else:
			Global.isHovering = false
	if event.is_action_released("ui_jump") && Global.isHovering:
		Global.isHovering = false
	#player melee attack

	if event.is_action_pressed("attack"):
		if Global.mechState == 0 && parent.isGrounded:
			$"../Human/PlayerMeleeTargetArea/CollisionShape2D".disabled = false
		else:
			$"../Human/PlayerMeleeTargetArea/CollisionShape2D".disabled = true
		if Global.mechState == 1:
			#mechRangedAttack
			var fireball = FIREBALL.instance()
			fireball._set_direction(parent.facingDirection)
			get_parent().add_child(fireball)
			fireball.global_position = $"../Mech/RangedAttackPos".global_position


