extends CharacterBody2D

#var velocity : Vector2
var speed : float
var landed : bool
@export var bouncePower : float
var bounced_last_frame
var rng = RandomNumberGenerator.new()

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Called when the node enters the scene tree for the first time.
func _ready():
	landed = false
	bounced_last_frame = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += gravity*delta
	if not landed:
		#velocity *= delta * speed
		var colInfo = move_and_collide(velocity * delta)
		#move_and_slide()
		#if(get_slide_collision_count() > 0):
			#colInfo = get_slide_collision(0)
		if colInfo: 
			velocity = velocity.slide(colInfo.get_normal())
			if colInfo.get_collider().name.substr(0, 8) == "Platform":
				#print(col_info.get_collider().name)
				print("HEWWO NEMO")
				colInfo.get_collider().break_platform()
			var normal = colInfo.get_normal()
			var angle = normal.angle_to(Vector2.UP) * 180/PI
			#print("Normal angle: " + str(angle))
			
#			print("landed on solid ground")
#			velocity = Vector2.ZERO
#			freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
#			freeze = true
#			landed = true
#			return
			if abs(angle) < 75 or velocity.length() < 1:
				#print("landed on solid ground")
				#velocity = Vector2.ZERO
				landed = true
				if (rng.randi_range(0,1) == 0):
					$GrappleHitAudio1.play()
				else:
					$GrappleHitAudio2.play()
				
			elif abs(angle) > 130:
				#print("hit a ceiling")
				velocity.x *= bouncePower
#				velocity.y = 0
			else:
				velocity = velocity.bounce(colInfo.get_normal().normalized())
				#print("normal bounce")
				velocity.x *= bouncePower
				velocity.y += bouncePower
				
			bounced_last_frame = true
		
		else:
			bounced_last_frame = false

func apply_force(force : Vector2):
	velocity += force
	pass
