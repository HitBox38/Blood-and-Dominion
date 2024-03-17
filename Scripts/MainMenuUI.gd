extends Control

var tutorial_menu_shown = false

func _on_start_game_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")

func _on_tutorial_menu_button_pressed():
	$TutorialMenu.visible = true
	$StartGameButton.visible = false
	$TutorialMenuButton.visible = false

func _on_return_button_pressed():
	$TutorialMenu.visible = false
	$StartGameButton.visible = true
	$TutorialMenuButton.visible = true
