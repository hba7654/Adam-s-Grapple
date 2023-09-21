extends Label

var seconds = 0;
var minutes = 0;
var hours = 0;
var timeStringFormat = "%0*d:%0*d:%0*.3f"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	seconds += delta;
	if (seconds >= 60):
		seconds -= 60
		minutes += 1
	if (minutes >= 60):
		minutes -= 60
		hours += 1
	text = timeStringFormat % [2, hours, 2, minutes, 6, seconds]
	pass
