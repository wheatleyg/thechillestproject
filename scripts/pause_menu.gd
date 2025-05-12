extends Control

@onready var timer: Timer = $Timer
@onready var flashing_labels: Control = $Panel/FlashingLabels
@onready var settings_menu = preload("uid://c423n2bdel6cx")
@onready var quit_confirmation: Panel = $QuitConfirmation
@onready var chill_wizard: player = $"../PlayerManager/ChillWizard"

@onready var pause_panel: Panel = $Panel
@onready var game_over_panel: Panel = $GameOver
@onready var revive_button: Button = $GameOver/VBoxContainer/ButtonsContainer/retry_button
@onready var revive_label: Label = $GameOver/VBoxContainer/StatsContainer/LevelsLabel

@onready var return_button: Button = $Panel/VBoxContainer2/return_button
@onready var settings_button = $Panel/VBoxContainer2/settings_button
@onready var quit_button = $Panel/VBoxContainer2/quit_button

@onready var quit_cancel = $QuitConfirmation/VBoxContainer/HBoxContainer/quit_cancel
@onready var score_label: Label = $GameOver/VBoxContainer/StatsContainer/ScoreLabel
@onready var levels_label: Label = $GameOver/VBoxContainer/StatsContainer/LevelsLabel





var time := 0.0
var speed := 0.7 # Controls how fast the fade happens
var is_showing := false
var transitioning := false
var tween

var game_over = false
var revives_left = 0  # Starting number of revives
#signal opened_through_pause # for settings menu to disable it's transition and panel.

func _ready():
	chill_wizard.player1_died.connect(game_over_moment)

	set_anchors_preset(Control.LayoutPreset.PRESET_TOP_LEFT) #this line is only to stop 1 warning

	var viewport_size = get_viewport().get_visible_rect().size
	set_deferred("size", viewport_size)
	modulate.a = 0.0

	# Hide confirmation dialog initially
	if quit_confirmation.visible == true:
		quit_confirmation.hide()

func _process(delta):
	time += delta * speed
	# Sine wave goes from 0 to 1 smoothly
	var alpha = (sin(time * PI * 2) + 1.0) / 2.0
	flashing_labels.modulate.a = alpha

	if game_over == false:
		if Input.is_action_just_pressed("escape"):
			toggle_transition(false)
			return_button.grab_focus()
	else:
		pass

func toggle_transition(game_over: bool):
	if transitioning:
		return  # dont allow toggle while fading
	if is_showing:
		if not game_over:  # Only allow unpausing if not in game over state
			get_tree().paused = false
			fade_out()
	else:
		get_tree().paused = true
		fade_in()



func fade_in():
	show()
	is_showing = true
	transitioning = true
	visible = true
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_callback(Callable(self, "_on_fade_complete"))

func fade_out():

	is_showing = false
	transitioning = true
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_callback(Callable(self, "hide"))
	tween.tween_callback(Callable(self, "_on_fade_complete"))
	await tween.finished
	hide()


func _on_fade_complete():
	transitioning = false


func _on_settings_button_pressed() -> void:
	var settings_instance = settings_menu.instantiate()
	settings_instance.opened_from_pause = true
	add_child(settings_instance)
	settings_instance.closed_in_pause.connect(switch_focus_when_settings_closed)

func _on_return_button_pressed() -> void:
	toggle_transition(false)


func _on_quit_button_pressed() -> void:
	pause_panel.hide()
	quit_confirmation.show()
	quit_cancel.grab_focus()

func _on_quit_confirm_pressed() -> void:
	get_tree().quit()

func _on_quit_cancel_pressed() -> void:
	pause_panel.show()
	quit_confirmation.hide()
	quit_button.grab_focus()

func switch_focus_when_settings_closed():
	settings_button.grab_focus()

func game_over_moment():
	game_over = true
	toggle_transition(true)
	pause_panel.visible = false
	game_over_panel.visible = true
	score_label.text = "SCORE: " +  str(GameManager.crystals)
	levels_label.text = "LEVELS CLEARED " + str(GameManager.levels_passed)


"""
	# Update revive button state
	if revives_left <= 0:
		revive_button.disabled = true
		revive_button.text = "NO REVIVES LEFT"
	else:
		revive_button.disabled = false
		revive_button.text = "REVIVE (%d LEFT)" % revives_left


func _on_revive_button_pressed() -> void:
	if revives_left > 0:
		revives_left -= 1
		game_over = false
		chill_wizard.health = 3  # Reset health
		chill_wizard.health_manager(0)  # Update health display
		game_over_panel.visible = false
		pause_panel.visible = true
		toggle_transition(false)
		revive_button.text = "REVIVE (%d LEFT)" % revives_left
"""


func _on_submit_score_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/game_over_score_entry.tscn")


func _on_retry_button_pressed() -> void: #actually main menu
	GameManager._reset()
	get_tree().change_scene_to_file("res://scenes/ui/menus/main_menu.tscn")


func _on_main_menu_button_pressed() -> void: #actually quit
	get_tree().quit()
