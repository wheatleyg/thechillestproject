extends Control

@onready var click_effect: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation: AnimationPlayer = $AnimationPlayer


func _ready():
	animation.play("fade_out")

func _on_start_button_pressed() -> void:
	click_effect.play()


func _on_setttings_button_pressed() -> void:
	click_effect.play()
	print("settings button pressed")
	animation.play("fade_in")
	await $AudioStreamPlayer.finished
	animation.play("RESET")
	get_tree().change_scene_to_file("res://scenes/ui/menus/settings_menu.tscn")

func _on_exit_button_pressed() -> void:
	click_effect.play()
	print("Player closed game :(")
	animation.play("fade_in")
	await $AudioStreamPlayer.finished
	get_tree().quit()
