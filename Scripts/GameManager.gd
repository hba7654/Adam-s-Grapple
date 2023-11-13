extends Node2D

@export var pauseMenu : Node
@export var playerNode : Node
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("esc_pressed"):
		if get_tree().paused == true:
			pauseMenu.close_pause_menu()
		else:
			pauseMenu.open_pause_menu()



