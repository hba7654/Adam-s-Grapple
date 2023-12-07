extends Label

var maxHeight = 0.0
var currentHeight = 0.0
var heightString = ""
var heightStringFormat = "%.2f / %.2f" 
var startHeight = 0.0
@export var playerNode : Node #this should be the physics body for the character. not the sprite or collision shape
var tracking = false

# need to figure out what the "starting" y is to base all the numbers around (this may need to wait until level is started/done)

# Called when the node enters the scene tree for the first time.
func _ready():
	startHeight = get_node("%GameManager").get_position().y * -1
	text = ""
	#startHeight = playerNode.get_position().y * -1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (tracking):
		currentHeight = (playerNode.get_position().y * -1) - startHeight
		#print (currentHeight - startHeight)
		if (currentHeight > maxHeight):
			maxHeight = currentHeight
		heightString = heightStringFormat % [currentHeight, maxHeight]
		text = heightString
	pass


func _on_start_tracking_height_area_body_entered(body):
	tracking = true
	pass # Replace with function body.
