extends RigidBody2D

var velocity : Vector2
var speed : float
var landed : bool
@export var bouncePower : float

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Called when the node enters the scene tree for the first time.
func _ready():
	landed = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#velocity.y += gravity*delta
	if not landed:
		var colInfo = move_and_collide(velocity.normalized() * delta * speed)
		if !colInfo: return

		#bouncing the hook off a wall
		var normal = colInfo.get_normal()
		if abs(normal.angle_to(Vector2.UP)) < PI/2:
			print("landed on solid ground")
			velocity = Vector2.ZERO
			freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
			freeze = true
			landed = true
		elif abs(normal.angle_to(Vector2.DOWN)) < PI/2:
			print("hit a ceiling")
			velocity.x = 0
			velocity.y = 0
		else:
			velocity = velocity.bounce(colInfo.get_normal().normalized())
			print("normal bounce")
			velocity.x *= bouncePower
			velocity.y += bouncePower
