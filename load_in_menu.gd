extends Control

@onready var enemy_1_res = preload("uid://eswdgxaofm4g")
@onready var enemy_2_res = preload("uid://cvb1x5l5grhq7")
@onready var enemy_3_res = preload("uid://b7tjv2ly54mcr")
@onready var enemy_box: GridContainer = $"Panel/Enemy box"
@onready var label: Label = $Panel/Label
@onready var animation: AnimationPlayer = $Panel/AnimationPlayer


# INPUTS HERE 
var continue_button = "p1_a"
var is_transitioning = false

func _ready() -> void:
	var enemies = {
	0:enemy_1_res,
	1:enemy_2_res,
	2:enemy_3_res
}

# Set label to show whatever button to continue, yeaa
	label.text = "PRESS %s TO CONTINUE!".replace("%s", "P1 SELECT")


	
	for i in range(len(enemies)):
		var current_enemy = enemies[i]
		enemy_box.get_node("Label" + str(i+1)).text = " = " + str(current_enemy.crystals_worth)



func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed(continue_button):
		if is_transitioning == true:
			return
	else:
		is_transitioning = true
		#click_effect.play()
		print("settings button pressed")
		animation.play("fade_in")
		await $AudioStreamPlayer.finished
		get_tree().change_scene_to_file("res://scenes/ui/menus/settings_menu.tscn")
