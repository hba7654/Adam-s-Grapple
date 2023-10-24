#extends CharacterBody2D
#
#
#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#
#
#func _physics_process(delta):
#	# Add the gravity.
#	if not is_on_floor():
#		velocity.y += gravity * delta
#
#	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY
#
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("ui_left", "ui_right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#
#	move_and_slide()
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const hookPath = preload("res://Prefabs/Rope/hook.tscn")

var hookDirVector : Vector2
var shotHook : bool
var hookInstance
var hookPos
var hooked : bool
var currentRopeLength

@export var maxHookPower : float
@export var hookPowerMult : float
@export var maxRopeLength : float
@export var swingSpeed : float
@export var pullStrength : float
@export var shiftStrength : float


var line
var frame_counter

func _ready():
	shotHook = false
	line = $Line2D
	line.show()
	currentRopeLength = maxRopeLength
	frame_counter = 0


func _physics_process(delta):
	frame_counter += 1
	#_draw()
	#print(global_position)
	#Gravity!
	#velocity = Velocity

	#=====================
	#GRAVITY
	#=====================
	if not is_on_floor():
		velocity.y += gravity * delta
		#print("adding gravity in frame " + str(frame_counter))
	elif not hooked:
		velocity.x = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("ui_left", "ui_right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#	move_and_slide()
	
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

	if shotHook and hookInstance.landed:
		hooked = true
		#create rope
		currentRopeLength = global_position.distance_to(hookInstance.global_position)
		print("Current Rope Length: " + str(currentRopeLength))
#		print("Hook is at " + str(hookInstance.global_position) + "at frame " + str(frame_counter))
		#handle input
		if Input.is_action_pressed("retract") and currentRopeLength > 0:
			print("RETRACT")
			currentRopeLength-=1
		elif Input.is_action_pressed("expand") and currentRopeLength < maxRopeLength:
			print("EXTEND")
			currentRopeLength += 1
		
		if Input.is_action_just_pressed("shift_right"):
			velocity += Vector2(shiftStrength*delta, 0)
		elif  Input.is_action_just_pressed("shift_left"):
			velocity -= Vector2(shiftStrength*delta, 0)
		#do movement
		swing(delta)
		#velocity *= 0.975 # swing speed
		
	move_and_slide()

func aim(delta, dirVector, power):
	var max_points
	var temp_mask = $Line2D/CollisionTest.collision_mask
	var temp_layer = $Line2D/CollisionTest.collision_layer
	
	if not hooked:
		$Line2D/CollisionTest.collision_mask = temp_mask
		$Line2D/CollisionTest.collision_layer = temp_layer
		max_points = 5
		line.clear_points()
		line.default_color = Color.WHITE
		var pos = $HookStart.position
		var vel = dirVector * power
		var num_points
		var passed = 0
		for i in max_points:
			line.add_point(pos)
			vel.y += gravity * delta
			
			var collision_test = $Line2D/CollisionTest
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
		return num_points
	
	else:
		$Line2D/CollisionTest.collision_mask = 0
		$Line2D/CollisionTest.collision_layer = 0
		max_points = currentRopeLength
		line.clear_points()
		line.default_color = Color.BROWN
		var pos = $Sprite2D.position
		var vel = (hookInstance.global_position - global_position).normalized()
		var num_points
		var passed = 0
		for i in max_points:
			line.add_point(pos)
#			vel.y += gravity * delta

#			var collision_test = $Line2D/CollisionTest
#			var collision_info = collision_test.move_and_collide(vel*delta, false, true, true)
			num_points = i

			pos += vel
#			collision_test.position = pos

#			if collision_info:
#				if passed < 3:
#					passed+=1
#					pass
#				else:
#					break

		#print("number of points in line is " + str(num_points))
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
	

#func _draw():
#	if hooked:
#		print("DRAWING ROPE")
#		draw_line($HookStart.global_position, hookInstance.global_position, Color.CYAN, 10, true)
#	else:
#		print("NO LINE")
#		draw_line($HookStart.global_position, Vector2.ZERO, Color.CYAN, 10, true)
		
