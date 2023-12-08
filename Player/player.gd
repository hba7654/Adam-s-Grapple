extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const hookPath = preload("res://Prefabs/hook.tscn")

var hookDirVector : Vector2
var shotHook : bool
var hookInstance
var hookPos
var hooked : bool
var currentRopeLength
var shifted_left : bool
var shifted_right : bool
var direction_sign : int #positive = right
var heightAtStartOfFall : float
var on_ice : bool
#var area : int

@export var maxHookPower : float
@export var hookPowerMult : float
@export var maxRopeLength : float
@export var swingSpeed : float
@export var pullStrength : float
@export var shiftStrength : float
@export var jump_boost_strength : float
@export var crawl_speed : float
@export var swing_dampener : float
@export var bgs : Array[Sprite2D]
@export var area_1_fade_start : int
@export var area_1_fade_end : int
@export var area_2_fade_start : int
@export var area_2_fade_end : int
@export var area_3_fade_start : int
@export var area_3_fade_end : int
@export var area_4_fade_start : int
@export var area_4_fade_end : int


var arc_line
var rope_line
var frame_counter

func _ready():
	shotHook = false
	arc_line = $ArcLine
	arc_line.show()
	rope_line = $Rope
	rope_line.hide()
	currentRopeLength = maxRopeLength
	frame_counter = 0
	shifted_left = false
	shifted_right = false
	direction_sign = true
	heightAtStartOfFall = 0.0
	on_ice = false
	
		
	

#func _process(delta):
	##BREAKABLE PLATFORMS
#	var col_info = get_last_slide_collision()
#	if col_info:
#		print(col_info.get_collider())
#		if col_info.get_collider().name.substr(0, 8) == "Platform":
#			print(col_info.get_collider().name.substr(0, 8))
#			print("HEWWO NEMO")
#			col_info.get_collider().break_platform()

func _physics_process(delta):
	if Input.is_action_pressed("area1"):
		global_position = Vector2(528,456)
	elif Input.is_action_pressed("area2"):
		global_position = Vector2(654, -1171)
	
	frame_counter += 1
	
	#=====================
	#BACKGROUNDS
	#=====================
	#Area 1
	if global_position.y >= 0:
		bgs[0].modulate = Color(1, 1, 1, 1)
		bgs[1].modulate = Color(1, 1, 1, 0)
		bgs[2].modulate = Color (1,1,1,0)
		bgs[3].modulate = Color (1,1,1,0)
		bgs[4].modulate = Color (1,1,1,0)
	#Area 1/2
	elif global_position.y <= area_1_fade_start and global_position.y >= area_1_fade_end:
		bgs[0].modulate = Color(1, 1, 1, ((global_position.y - area_1_fade_end) / (area_1_fade_start - area_1_fade_end)))
		bgs[1].modulate = Color(1, 1, 1, 1-((global_position.y - area_1_fade_end) / (area_1_fade_start - area_1_fade_end)))
		bgs[2].modulate = Color (1,1,1,0)
		bgs[3].modulate = Color (1,1,1,0)
		bgs[4].modulate = Color (1,1,1,0)
	#Area 2/3
	elif global_position.y <= area_2_fade_start and global_position.y >= area_2_fade_end:
		bgs[1].modulate = Color(1, 1, 1, ((global_position.y - area_2_fade_end) / (area_2_fade_start - area_2_fade_end)))
		bgs[2].modulate = Color(1, 1, 1, 1-((global_position.y - area_2_fade_end) / (area_2_fade_start - area_2_fade_end)))
		bgs[0].modulate = Color (1,1,1,0)
		bgs[3].modulate = Color (1,1,1,0)
		bgs[4].modulate = Color (1,1,1,0)
	#Area 3/4
	elif global_position.y <= area_3_fade_start and global_position.y >= area_3_fade_end:
		bgs[2].modulate = Color(1, 1, 1, ((global_position.y - area_3_fade_end) / (area_3_fade_start - area_3_fade_end)))
		bgs[3].modulate = Color(1, 1, 1, 1-((global_position.y - area_3_fade_end) / (area_3_fade_start - area_3_fade_end)))
		bgs[0].modulate = Color (1,1,1,0)
		bgs[1].modulate = Color (1,1,1,0)
		bgs[4].modulate = Color (1,1,1,0)
	#Area 4/5
	elif global_position.y <= area_4_fade_start and global_position.y >= area_4_fade_end:
		bgs[3].modulate = Color(1, 1, 1, ((global_position.y - area_4_fade_end) / (area_4_fade_start - area_4_fade_end)))
		bgs[4].modulate = Color(1, 1, 1, 1-((global_position.y - area_4_fade_end) / (area_4_fade_start - area_4_fade_end)))
		bgs[0].modulate = Color (1,1,1,0)
		bgs[1].modulate = Color (1,1,1,0)
		bgs[2].modulate = Color (1,1,1,0)
	
	#=====================
	#GRAVITY
	#=====================
	if not is_on_floor():
		velocity.y += gravity * delta
		if (get_position().y * -1 > heightAtStartOfFall || heightAtStartOfFall == 0.0):
			heightAtStartOfFall = get_position().y * -1
			print(heightAtStartOfFall)
		#print("adding gravity in frame " + str(frame_counter))
	elif not hooked and not on_ice:
		velocity.x = 0
	if is_on_floor():
		if (get_position().y*-1 < heightAtStartOfFall - 1000):
			print("play sound")
		heightAtStartOfFall = get_position().y * -1
		print("on floor", heightAtStartOfFall)
	if on_ice:
		if !$AudioNodes/IceAudio.playing:
			$AudioNodes/IceAudio.play()
	
	#=====================
	#RESETTING SHIFT VARS
	#=====================
	if (direction_sign * velocity.x) < 0:
		shifted_left = false
		shifted_right = false
	direction_sign = sign(velocity.x)
	if direction_sign > 0:
		$DudeSprite.flip_h = false
	elif direction_sign < 0:
		$DudeSprite.flip_h = true
	
	#=====================
	#AIMING
	#=====================
	var mouse = get_local_mouse_position()
	$HookStart.position.x = 25 * cos((-$HookStart.global_position + get_global_mouse_position()).angle())
	$HookStart.position.y = 25 * sin((-$HookStart.global_position + get_global_mouse_position()).angle())
	var hookPower = mouse.length()
	#print("Mouse distance away is: " + str(hookPower))

	hookDirVector = mouse.normalized()
	hookPower *= hookPowerMult
	#print("Hook power is: " + str(hookPower))

	if (hookPower > maxHookPower):
		hookPower = maxHookPower
		#print("Hook power is now: " + str(hookPower))

	var num_points = aim(delta, hookDirVector, hookPower)
	#print("number of points in line is " + str(num_points))
	
	#=====================
	#GRAPPLING
	#=====================
	if(Input.is_action_just_pressed("hook")):
		#The frame the mouse was clicked, shoot the hook
		$AudioNodes/GrappleLaunchAudio.play()
		if shotHook:
			shotHook = false
			hooked = false
			hookInstance.set_name("temp")
			hookInstance.queue_free()
		shoot(hookDirVector, hookPower, num_points)
		
	elif(Input.is_action_just_pressed("release")):
		#The frame the mouse was released
		if (shotHook):
			shotHook = false
			hooked = false
			hookInstance.queue_free()
			
	elif(Input.is_action_just_pressed("jump")):
		#The frame the mouse was released
		velocity *= jump_boost_strength
		if (shotHook):
			shotHook = false
			hooked = false
			hookInstance.queue_free()
			
	if Input.is_action_pressed("shift_right") and is_on_floor() and not on_ice:
		velocity.x += crawl_speed*delta 
		if !$AudioNodes/DragAudio.playing:
			$AudioNodes/DragAudio.play()
	elif Input.is_action_pressed("shift_left") and is_on_floor() and not on_ice:
		velocity.x -= crawl_speed*delta 
		if !$AudioNodes/DragAudio.playing:
			$AudioNodes/DragAudio.play()
		
	
	#Create Rope
	if shotHook and hookInstance.landed:
		currentRopeLength = global_position.distance_to(hookInstance.global_position)
		if currentRopeLength < maxRopeLength:
			hooked = true
			create_rope()
			#if hookInstance.landed:
			#handle input
			if Input.is_action_pressed("retract") and currentRopeLength > 10:
				#print("RETRACT")
				currentRopeLength-=1
				if !$AudioNodes/GrappleRetract.playing:
					$AudioNodes/GrappleRetract.play()
			elif Input.is_action_pressed("expand") and currentRopeLength < maxRopeLength and not is_on_floor():
				#print("EXTEND")
				currentRopeLength += 1
			if Input.is_action_just_released("retract"):
				if $AudioNodes/GrappleRetract.playing:
					$AudioNodes/GrappleRetract.stop()
			if Input.is_action_just_pressed("shift_right") and not shifted_right and not is_on_floor():
				shifted_right = true
				velocity.x += shiftStrength*delta
			elif  Input.is_action_just_pressed("shift_left") and not shifted_left and not is_on_floor():
				shifted_left = true
				velocity.x -= shiftStrength*delta
			#do movement
			swing(delta)
			#velocity *= swing_dampener
		
	move_and_slide()

func aim(delta, dirVector, power):
	var max_points
	var temp_mask = $ArcLine/CollisionTest.collision_mask
	var temp_layer = $ArcLine/CollisionTest.collision_layer
	
	rope_line.hide()
	$ArcLine/CollisionTest.collision_mask = temp_mask
	$ArcLine/CollisionTest.collision_layer = temp_layer
	max_points = 5
	arc_line.clear_points()
	arc_line.default_color = Color.WHITE
	var pos = $HookStart.position
	var vel = dirVector * power
	var num_points
	var passed = 0
	for i in max_points:
		arc_line.add_point(pos)
		vel.y += gravity * delta
		
		var collision_test = $ArcLine/CollisionTest
		var collision_info = collision_test.move_and_collide(vel*delta, false, true, true)
		num_points = i
		
		pos += vel * delta
		collision_test.position = pos
		
		if collision_info:
			if passed < 3:
				passed+=1
				pass
			else:
				break
	return num_points
		
func create_rope():
	var max_points = currentRopeLength
	rope_line.clear_points()
	rope_line.default_color = Color.BROWN
	var pos = $HookStart/Sprite2D.position
	var vel = (hookInstance.global_position - global_position).normalized()
	var num_points
	var passed = 0
	for i in max_points:
		rope_line.add_point(pos)
		num_points = i
		pos += vel
	rope_line.show()
	$Rope/RopeCollision.scale.x = abs(vel.x * num_points)/10
	$Rope/RopeCollision.global_position = (global_position + hookInstance.global_position)/2
	$Rope/RopeCollision.rotation = vel.angle()
	return num_points

func shoot(dirVector, power, points):
	shotHook = true
	hookInstance = hookPath.instantiate()
	hookInstance.global_position = $HookStart.global_position
	get_parent().add_child(hookInstance);
	hookInstance.velocity = dirVector*power
	hookInstance.speed = power



func swing(delta):
	#print("Current Rope Length: " + str(currentRopeLength))
	var radius = global_position - hookInstance.global_position
	var angle = radius.angle_to(velocity)#acos(radius.dot(velocity) / (radius.length() * velocity.length()))
	print(angle * (180/PI))
	var rad_vel = cos(angle) * velocity.length()
#	print(velocity.length())
	#If player stays spinning around a block in the air for a while, pull them down a bit
	if abs(angle*180/PI) < 90 and not is_on_floor() or velocity.length() > 200:
		velocity += radius.normalized() * -rad_vel
		currentRopeLength -= delta
#		if abs(angle) <= PI/3:
#			velocity.x*=swing_dampener 
		
	var distance = global_position.distance_to(hookInstance.global_position)
	#print("Distance from Rope: " + str(distance))
	if  distance > currentRopeLength:
#		print("Distance from player to hook: " + str(distance))
#		print("Rope Length: " + str(currentRopeLength))
#		print("Radius" + str(radius))
		global_position = hookInstance.global_position + radius.normalized() * currentRopeLength
		#velocity -= radius.normalized() * delta * swingSpeed
		if is_on_floor():
			velocity -= Vector2(0, pullStrength*delta)
	elif distance < currentRopeLength and not is_on_floor():
#		velocity += radius.normalized() * delta * swingSpeed
		global_position = hookInstance.global_position + radius.normalized() * currentRopeLength
		
	if not is_on_floor():
		velocity -= radius.normalized() * delta * swingSpeed
	else:
		velocity.x *= 0.4
		
func apply_force(force : Vector2):
	velocity += force
	pass

func _on_rock_delete_hook():
	print("i was told to delete this hook")
	if (shotHook == true):
		shotHook = false
		hooked = false
		hookInstance.queue_free()
	pass # Replace with function body.

func change_area(area_num):
	for i in bgs.size():
		if i == area_num-1:
			bgs[i].modulate = Color(1, 1, 1, 1)
		else:
			bgs[i].modulate = Color(1, 1, 1, 0)



