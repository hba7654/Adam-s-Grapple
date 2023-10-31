extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const hookPath = preload("res://Prefabs/Rope/hook.tscn")

var hookDirVector : Vector2
var shotHook : bool
var hookInstance
var hookPos
var hooked : bool
var currentRopeLength
var shifted_left : bool
var shifted_right : bool
var direction_sign : int #positive = right

@export var maxHookPower : float
@export var hookPowerMult : float
@export var maxRopeLength : float
@export var swingSpeed : float
@export var pullStrength : float
@export var shiftStrength : float
@export var jump_boost_strength : float


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


func _physics_process(delta):
	frame_counter += 1

	#=====================
	#GRAVITY
	#=====================
	if not is_on_floor():
		velocity.y += gravity * delta
		#print("adding gravity in frame " + str(frame_counter))
	elif not hooked:
		velocity.x = 0
	
	#=====================
	#RESETTING SHIFT VARS
	#=====================
	if (direction_sign * velocity.x) < 0:
		shifted_left = false
		shifted_right = false
	direction_sign = sign(velocity.x)
	
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
		if shotHook:
			shotHook = false
			hooked = false
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
	
	#Create Rope
	if shotHook and hookInstance.landed:
		create_rope()
		currentRopeLength = global_position.distance_to(hookInstance.global_position)
		if currentRopeLength < maxRopeLength:
			hooked = true
			
			#handle input
			if Input.is_action_pressed("retract") and currentRopeLength > 0:
				print("RETRACT")
				currentRopeLength-=1
			elif Input.is_action_pressed("expand") and currentRopeLength < maxRopeLength:
				print("EXTEND")
				currentRopeLength += 1
			
			if Input.is_action_just_pressed("shift_right") and not shifted_right:
				shifted_right = true
				velocity += Vector2(shiftStrength*delta, 0)
			elif  Input.is_action_just_pressed("shift_left") and not shifted_left:
				shifted_left = true
				velocity -= Vector2(shiftStrength*delta, 0)
				
			#do movement
			swing(delta)
		
	move_and_slide()

func aim(delta, dirVector, power):
	var max_points
	var temp_mask = $ArcLine/CollisionTest.collision_mask
	var temp_layer = $ArcLine/CollisionTest.collision_layer
	
	#if not hooked:
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
	
	#print("number of points in line is " + str(num_points))
	#arc_line.show()
	return num_points
	
#	else:
#		#arc_line.hide()
#		max_points = currentRopeLength
#		rope_line.clear_points()
#		rope_line.default_color = Color.BROWN
#		var pos = $Sprite2D.position
#		var vel = (hookInstance.global_position - global_position).normalized()
#		var num_points
#		var passed = 0
#		for i in max_points:
#			rope_line.add_point(pos)
#			num_points = i
#
#			pos += vel
#		rope_line.show()
#		return num_points
		
func create_rope():
	var max_points = currentRopeLength
	rope_line.clear_points()
	rope_line.default_color = Color.BROWN
	var pos = $Sprite2D.position
	var vel = (hookInstance.global_position - global_position).normalized()
	var num_points
	var passed = 0
	for i in max_points:
		rope_line.add_point(pos)
		num_points = i

		pos += vel
	rope_line.show()
	return num_points

func shoot(dirVector, power, points):
	shotHook = true
	#	var mouse = get_local_mouse_position()
	#	var hookPower = mouse.length()
	#	print("Mouse distance away is: " + str(hookPower))
	#
	#	hookDirVector = mouse.normalized()
	#	hookPower *= hookPowerMult
	#	print("Hook power is: " + str(hookPower))
	#
	#	if (hookPower > maxHookPower):
	#		hookPower = maxHookPower
	#		print("Hook power is now: " + str(hookPower))

	hookInstance = hookPath.instantiate()
	hookInstance.global_position = $HookStart.global_position
	get_parent().add_child(hookInstance);
	hookInstance.velocity = dirVector
	hookInstance.speed = power





#	#TODO: - Create hook instance at player position
#	#		- add force with magnitude hookPower, direction hookDirVector



#REWORKING GRAPPLING
#see bottom of hook.gd for more details
#in _physics_process():
	#recalculate mouse position and dir vector, pass information to $Hook.calculate_path()
	#check if hook landed
		#if so, allow traveling along rope
#in _input():
	#handle mouse input, call $Hook.shoot() on mouse press and $Hook.release() on mouse release
	#handle kb input, if allowed to do so, to travel up and down rope

func swing(delta):
	var radius = global_position - hookInstance.global_position
	var angle = acos(radius.dot(velocity) / (radius.length() * velocity.length()))
	var rad_vel = cos(angle) * velocity.length()
	if not is_on_floor():
		print("flyin")
		velocity += radius.normalized() * -rad_vel
	
	var distance = global_position.distance_to(hookInstance.global_position)
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
		
	
	#velocity += radius.normalized() * delta * swingSpeed
	
