extends Area2D

@export var playerNode : Node
var bodiesInside = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_body_entered(body):
	bodiesInside.push_back(body)
	pass
	
func _on_body_exited(body):
	bodiesInside.remove_at(bodiesInside.find(body))
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for body in bodiesInside:
		body.apply_force(Vector2(-100,0))
	pass
