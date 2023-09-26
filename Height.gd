extends Label

var maxHeight = 0.0
var currentHeight = 0.0
var heightString = ""
var heightStringFormat = "%.2f / %.2f" 
#todo: need to get reference to player and then grab its y from its transform
#	actually - maybe not. if the position of the height is always linked to the player, then you can find the offset between the height node and the player
#	and make it work. going to have to be relatively careful with this as UI changes could make this break if we go this route and we aren't paying attention 
#also need to figure out what the "starting" y is to base all the numbers around (this may need to wait until level is started/done)
@export var playerNode : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	currentHeight = playerNode.get_position().y * -1
	print (currentHeight)
	if (currentHeight > maxHeight):
		maxHeight = currentHeight
	heightString = heightStringFormat % [currentHeight, maxHeight]
	text = heightString
	pass
