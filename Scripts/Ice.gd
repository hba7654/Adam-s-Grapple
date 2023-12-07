extends Area2D

@export var playerNode : Node
var bodiesInside = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_body_entered(body):
	print("WAHOO")
	body.on_ice = true
	pass
	
func _on_body_exited(body):
	print("WAAAAAA")
	body.on_ice = false
	pass
