extends Control
signal resume
signal back_to_main_pressed

@onready var content : VBoxContainer = $%Content
@onready var options_menu : Control = $%OptionsMenu
@onready var resume_game_button: Button = $%ResumeGameButton

var cam_width
var cam_height

func _ready():
#	cam_width = ProjectSettings.get_setting("display/window/size/viewport_width")
#	cam_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	cam_width = get_viewport().get_visible_rect().size.x
	cam_height = get_viewport().get_visible_rect().size.y

func open_pause_menu():
	#Stops game and shows pause menu
	get_tree().paused = true
	show()
	resume_game_button.grab_focus()
	
func close_pause_menu():
	get_tree().paused = false
	hide()
	emit_signal("resume")

func _on_resume_game_button_pressed():
	close_pause_menu()


func _on_options_button_pressed():
	content.hide()
	options_menu.show()
	options_menu.position = get_parent().get_parent().global_position + Vector2(-cam_width/2 + 482, -cam_height/2 +200)
	options_menu.on_open()


func _on_options_menu_close():
	options_menu.hide()
	content.show()
	resume_game_button.grab_focus()

func _on_quit_button_pressed():
	get_tree().quit()


func _on_back_to_menu_button_pressed():
	close_pause_menu()
	EzTransitions.change_scene("res://Scenes/main_menu.tscn")
	emit_signal("back_to_main_pressed")

func _input(event):
	if (event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause")) and visible and !options_menu.visible:
		accept_event()
		close_pause_menu()
