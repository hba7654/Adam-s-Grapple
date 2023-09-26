extends Label

var maxHeight = 0.0
var currentHeight = 0.0
var heightString = ""
var heightStringFormat = "%.2f / %.2f" 
@export var playerNode : Node #this should be the physics body for the character. not the sprite or collision shape

# need to figure out what the "starting" y is to base all the numbers around (this may need to wait until level is started/done)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	currentHeight = playerNode.get_position().y * -1
	print (currentHeight)
	if (currentHeight > maxHeight):
		maxHeight = currentHeight
	heightString = heightStringFormat % [currentHeight, maxHeight]
	text = heightString
	pass
