extends RigidBody2D

var velocity : Vector2
var speed : float
var landed : bool
@export var bouncePower : float
var bounced_last_frame

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Called when the node enters the scene tree for the first time.
func _ready():
	landed = false
	bounced_last_frame = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#velocity.y += gravity*delta
	if not landed:
		var colInfo = move_and_collide(velocity.normalized() * delta * speed)
		if colInfo: 
			var normal = colInfo.get_normal()
			var angle = normal.angle_to(Vector2.UP) * 180/PI
			print("Normal angle: " + str(angle))
			
#			print("landed on solid ground")
#			velocity = Vector2.ZERO
#			freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
#			freeze = true
#			landed = true
#			return
			if bounced_last_frame or abs(angle) < 85:
				print("landed on solid ground")
				velocity = Vector2.ZERO
				freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
				freeze = true
				landed = true
			elif abs(angle) > 130:
				print("hit a ceiling")
				velocity.x = 0
				velocity.y = 0
			else:
				velocity = velocity.bounce(colInfo.get_normal().normalized())
				print("normal bounce")
				velocity.x *= bouncePower
				velocity.y += bouncePower
				
			bounced_last_frame = true
		
		else:
			bounced_last_frame = false
