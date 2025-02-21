extends Control


@onready var click_effect: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation: AnimationPlayer = $AnimationPlayer

var is_transitioning

func _ready():
	animation.play("fade_out")
	await $AnimationPlayer.animation_finished



func _on_back_button_pressed() -> void:
	if is_transitioning == true:
		return
	else:
		is_transitioning = true
		click_effect.play()
		animation.play("fade_in")
		await $AudioStreamPlayer.finished
		get_tree().change_scene_to_file("res://scenes/ui/menus/main_menu.tscn")
