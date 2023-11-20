extends RigidBody2D

var timer : float
var start_to_break : bool
var breaking : bool

@export var break_time : float
@export var regrow_time : float
var collision_layers
var collision_masks

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = 0
	start_to_break = false
	collision_layers = collision_layer
	collision_masks = collision_mask


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var col_info = move_and_collide(Vector2.ZERO)
	if col_info:
		print(col_info)
	
	if start_to_break:
		timer += delta
	
	#Breaking platform
	if breaking and timer >= break_time:
		visible = false
		#Disable collision
		collision_layer = 0
		collision_mask = 0
		breaking = false
		timer = 0
		$%Player._on_rock_delete_hook()
	
	#Regrowing Platform
	elif not breaking and timer >= regrow_time:
		visible = true
		#Disable collision
		collision_layer = collision_layers
		collision_mask = collision_masks
		start_to_break = false
		timer = 0
		

func break_platform():
	#print("collided w breakable")
	#print(body.name)
	#if (body.name == "Player" || body.name == "Hook" || body.name == "Leg1" || body.name == "Leg2"):
		#print(str(body.name) + "Collided")
	start_to_break = true
	breaking = true
