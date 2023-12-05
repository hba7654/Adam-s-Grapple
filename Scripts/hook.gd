extends CharacterBody2D

#var velocity : Vector2
var speed : float
var landed : bool
@export var bouncePower : float
var bounced_last_frame
var rng = RandomNumberGenerator.new()
var on_ice : bool

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Called when the node enters the scene tree for the first time.
func _ready():
	landed = false
	bounced_last_frame = false
	on_ice = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += gravity*delta
	if landed and not on_ice and is_on_floor():
		velocity.x = 0
	
	#if not landed:
		#velocity *= delta * speed
	var colInfo
	if(get_slide_collision_count() > 0):
		colInfo = get_slide_collision(0)
	if colInfo: 
		if colInfo.get_collider().name.substr(0, 8) == "Platform":
			#print(col_info.get_collider().name)
			print("HEWWO NEMO")
			colInfo.get_collider().break_platform()
		var normal = colInfo.get_normal()
		var angle = normal.angle_to(Vector2.UP) * 180/PI
		#print("Normal angle: " + str(angle))
		
		if abs(angle) < 75:
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
			landed = false
	else: 
		landed = false
			
		#bounced_last_frame = true
	#
	#else:
		#bounced_last_frame = false
			
	move_and_slide()

func apply_force(force : Vector2):
	velocity += force
	pass
