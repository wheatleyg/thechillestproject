extends Control

@onready var click_effect: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var start_button: Button = $Panel/VBoxContainer/start_button

var is_transitioning = false


func _ready():
	start_button.grab_focus()
	animation.play("fade_out")

func _on_start_button_pressed() -> void:
	click_effect.play()
	get_tree().change_scene_to_file("uid://dhgahvrnloiyl")


func _on_setttings_button_pressed() -> void:
	if is_transitioning == true:
		return
	else:
		is_transitioning = true
		click_effect.play()
		print("settings button pressed")
		animation.play("fade_in")
		await $AudioStreamPlayer.finished
		get_tree().change_scene_to_file("res://scenes/ui/menus/settings_menu.tscn")

func _on_exit_button_pressed() -> void:
	click_effect.play()
	print("Player closed game :(")
	animation.play("fade_in")
	await $AudioStreamPlayer.finished
	get_tree().quit()
