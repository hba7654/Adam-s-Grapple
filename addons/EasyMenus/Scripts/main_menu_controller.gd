extends Control
signal start_game_pressed

@onready var start_game_button: Button = $%StartGameButton
@onready var options_menu: Control = $%OptionsMenu
@onready var content: Control = $%Content 

func _ready():
	start_game_button.grab_focus()

func quit():
	get_tree().quit()
	
func open_options():
	options_menu.show()
	content.hide()
	options_menu.on_open()
	
func close_options():
	content.show();
	start_game_button.grab_focus()
	options_menu.hide()


func _on_start_game_button_pressed():
	EzTransitions.set_easing(2, 0)
	EzTransitions.set_trans(0, 2)
	EzTransitions.set_timers(2, 0.5, 2)
	EzTransitions.set_reverse(false, true)
	EzTransitions.set_textures("res://addons/ez_transitions/images/black_texture.png", "res://addons/ez_transitions/images/black_texture.png")
	EzTransitions.set_types(1, 1)
	EzTransitions.change_scene("res://Scenes/main-game.tscn")
	emit_signal("start_game_pressed")
