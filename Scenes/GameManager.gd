extends Node2D

@export var pauseMenu : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("esc_pressed"):
		get_tree().paused = !get_tree().paused
		if get_tree().paused == true:
			pauseMenu.show()
		else:
			pauseMenu.hide()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
