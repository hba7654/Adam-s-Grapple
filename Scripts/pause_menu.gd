extends Control


func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	
	


func _on_options_button_pressed():
	print_debug("YESSIR") 
