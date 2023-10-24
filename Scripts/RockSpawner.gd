extends Node2D

signal spawn(rock, location)

var fallingRock = load("res://Prefabs/falling_rock.tscn")
@export var interval : float
var currentTime : float

# Called when the node enters the scene tree for the first time.
func _ready():
	if interval == 0:
		interval = 3.0
	currentTime = interval
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	currentTime += delta
	if (currentTime >= interval):
		#spawn rock
		print("spawned rock")
		var newRock = fallingRock.instantiate()
		newRock.global_position = global_position
		print(newRock.get_position())
		add_child(newRock)
		currentTime = 0
	pass
