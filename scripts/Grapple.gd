extends Node2D

signal holdingObject()

onready var links = $Links	
var direction := Vector2(0,0)	
var tip := Vector2(0,0)			
var collision = null
var parent = get_parent()
var moveBlock = false


const SPEED = 150	# The speed with which the chain moves


# shoot() shoots the chain in a given direction
func shoot(dir: Vector2) -> void:
	direction = dir.normalized()	# Normalize the direction and save it
	Global.flying = true					# Keep track of our current scan
	tip = self.global_position		# reset the tip position to the player's position

# release() the chain
func release() -> void:
	moveBlock = false
	Global.holdingObject = null
	moveBlock = false
	Global.flying = false	# Not flying anymore	
	Global.hooked = false	# Not attached anymore

# Every graphics frame we update the visuals
func _process(_delta: float) -> void:
	self.visible = Global.flying or Global.hooked	# Only visible if flying or attached to something
	if not self.visible:
		return	# Not visible -> nothing to draw
	var tip_loc = to_local(tip)	# Easier to work in local coordinates
	# We rotate the links (= chain) and the tip to fit on the line between self.position (= origin = player.position) and the tip
	links.rotation = self.position.angle_to_point(tip_loc) - deg2rad(90)
	$Tip.rotation = self.position.angle_to_point(tip_loc) - deg2rad(90)
	links.position = tip_loc						# The links are moved to start at the tip
	links.region_rect.size.y = tip_loc.length()		# and get extended for the distance between (0,0) and the tip

# Every physics frame we update the tip position
func _physics_process(_delta: float) -> void:
	if Global.holdingObject:
		release()
	$Tip.global_position = tip	# The player might have moved and thus updated the position of the tip -> reset it
	if Global.flying:	
		$Tip.move_and_slide(direction * SPEED) 
		for i in $Tip.get_slide_count():
			collision = $Tip.get_slide_collision(i)
			print(collision)
			if moveBlock:
				Global.hooked = false	# Got something!
				Global.flying = true	# Not flying anymore
			else:
				Global.hooked = true	# Got something!
				Global.flying = false	# Not flying anymore
	tip = $Tip.global_position	# set `tip` as starting position for next frame


func _on_Area2D_body_entered(body):
	if body is MovableBlock:
		moveBlock = true
		direction = -direction
		body.set_velocity(direction*SPEED)
		body.isMoving = true
		Global.flying = true
		Global.hooked = false
