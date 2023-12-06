extends Area2D

@export var area_number : int
@export var fade_start : float
@export var fade_end : float
@export var area_start : float
@export var area_end : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	body.change_area(area_number)
