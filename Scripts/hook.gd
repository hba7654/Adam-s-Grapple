extends RigidBody2D

var velocity : Vector2
var speed : float
var landed : bool
@export var bounceDamper : float
@export var bouncePower : float

@export var timeTillDeletion : float
var timer = 0.0

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
		#var angle = abs(normal.angle())
		#print("Normal: " + str(normal) + " Angle: " + str(angle) + 
		#" \nAngle To Up: " + str(abs(normal.angle_to(Vector2.UP))) + " Angle To Down: " + str(abs(normal.angle_to(Vector2.DOWN))))
		#only bounce the hook off the wall if it hits the sides
		if(abs(normal.angle_to(Vector2.UP)) < 0.1):
			print("landed on solid ground")
			velocity = Vector2.ZERO
			freeze = true
			landed = true
			freeze = true
		else: if (abs(normal.angle_to(Vector2.DOWN)) < 0.1):
			print("hit a ceiling")
#			velocity.x = 0
#			velocity.y = 0
		else:
			velocity = velocity.bounce(colInfo.get_normal().normalized())
			print("normal bounce")
			velocity.x *= bouncePower
			velocity.y += bouncePower

	else:
		timer += delta
		if(timer >= timeTillDeletion) :
			get_parent().queue_free()

#REWORK HOOK COMPLETELY
	#On mouse hover create parabloic trajectory - DONE
	#On mouse click travel along trajectory - DONE
	#Rope added to hook in (small) segments until hook lands or max distance reached
	#Hook and rope have collision with environment but not with the player and not with each other
	#functions needed:
		#calculate_path(Vector2 dirVector) - DONE DIFFERENTLY, see aim() in player.gd
		#shoot() - DONE
		#add_segment(int index) - DONE
		#release()
		#
