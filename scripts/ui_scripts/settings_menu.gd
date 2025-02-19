extends Control


@onready var click_effect: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready():
	animation.play("fade_out")
	await $AnimationPlayer.animation_finished
	animation.play("RESET")



func _on_back_button_pressed() -> void:
	click_effect.play()
	animation.play("fade_in")
	await $AudioStreamPlayer.finished
	get_tree().change_scene_to_file("res://scenes/ui/menus/main_menu.tscn")
