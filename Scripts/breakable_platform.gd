extends RigidBody2D

var timer : float
var start_to_break : bool

@export var break_time : float

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = 0
	start_to_break = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if start_to_break:
		timer += delta
	
	if timer >= break_time:
		queue_free()

func _on_body_entered(body):
	print("collided w breakable")
	#print(body.name)
	if (body.name == "Player" || body.name == "Hook"):
		print(str(body.name) + "Collided")
		start_to_break = true
