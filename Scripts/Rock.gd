extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#replace 508 in this with whatever the appropriate number is. 
	# alternate option: delete it once it makes contact with a non-player object (this route is better, but there are currently no non-player objects)
	# only issue with option 2 is that depending on how often they spawn in, there could be a ton on screen 
	#if get_position().y >= 508:
		#print("ROCK DELETED")
		#queue_free()
	pass
