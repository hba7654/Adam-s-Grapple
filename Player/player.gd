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

var hookDirVector : Vector2
var shotHook : bool
const hookPath = preload("res://Prefabs/Rope/hook.tscn")
var hookInstance
@export var maxHookPower : float
@export var hookPowerMult : float

var line

func _ready():
	shotHook = false
	line = $Line2D
	line.show()


func _physics_process(delta):
	#Gravity!
	#velocity = Velocity

	#Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	#aiming
	var mouse = get_local_mouse_position()
	var hookPower = mouse.length()
	print("Mouse distance away is: " + str(hookPower))

	hookDirVector = mouse.normalized()
	hookPower *= hookPowerMult
	print("Hook power is: " + str(hookPower))

	if (hookPower > maxHookPower):
		hookPower = maxHookPower
		print("Hook power is now: " + str(hookPower))

	aim(delta, hookDirVector, hookPower)
	
	#Grappling
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		#The frame the mouse was clicked, shoot the hook
		if (!shotHook):
			shoot(hookDirVector, hookPower)
			#get_node("PinJoint2D").set_node_b(hookInstance.get_node("RopeSeg10").get_path())
		#else if hook landed
			#allow player movement
	else:
		#The frame the mouse was released
		if (shotHook):
			shotHook = false

			#Release rope
				#Detach player from rope

			#Disable movement (no rope to retract/expand)

func aim(delta, dirVector, power):
	var max_points = 300
	line.clear_points()
	var pos = Vector2.ZERO
	var vel = dirVector * power
	for i in max_points:
		line.add_point(pos)
		vel.y += gravity * delta
		
		var collision_test = $Line2D/CollisionTest
		var collision_info = collision_test.move_and_collide(vel*delta, false, true, true)
		if collision_info:
			vel = Vector2.ZERO
		
		
		pos += vel * delta
		collision_test.position = pos

func shoot(dirVector, power):
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
	add_child(hookInstance);
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
