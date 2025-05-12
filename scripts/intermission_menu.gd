extends Control


#i am making this with 300mg of caffiene in my blood!!
@onready var continue_button: Button = $Panel/ContinueButton
@onready var shop_button: Button = $Panel/ShopButton
@onready var score_label: Label = $Panel/ScoreLabel
@onready var level_label: Label = $Panel/LevelLabel



func _ready() -> void:
	shop_button.grab_focus()
	score_label.text = "SCORE: " + str(GameManager.crystals)
	level_label.text = "LEVEL: " + str(GameManager.levels_passed)
	


func _on_continue_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Level0.tscn")


func _on_shop_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/shop.tscn")
