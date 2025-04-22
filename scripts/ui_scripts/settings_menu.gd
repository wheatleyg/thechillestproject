extends Control

@onready var click_effect: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation: AnimationPlayer = $AnimationPlayer

@onready var master_volume_slider: HSlider = $Panel/MarginContainer/VBoxContainer/GridContainer/HSlider
@onready var music_volume_slider: HSlider = $Panel/MarginContainer/VBoxContainer/GridContainer/HSlider2
@onready var sfx_volume_slider: HSlider = $Panel/MarginContainer/VBoxContainer/GridContainer/HSlider3
@onready var master_value_label: Label = $Panel/MarginContainer/VBoxContainer/GridContainer/MasterValue
@onready var music_value_label: Label = $Panel/MarginContainer/VBoxContainer/GridContainer/MusicValue
@onready var sfx_value_label: Label = $Panel/MarginContainer/VBoxContainer/GridContainer/SFXValue
@onready var fullscreen_checkbox: CheckBox = $Panel/MarginContainer/VBoxContainer/GridContainer/CheckBox
@onready var vsync_checkbox: CheckBox = $Panel/MarginContainer/VBoxContainer/GridContainer/CheckBox2
@onready var panel: Panel = $Panel
@onready var back_button: Button = $Panel/MarginContainer/VBoxContainer/HBoxContainer/back_button

var is_transitioning = false
var master_bus_idx
var music_bus_idx
var sfx_bus_idx

var opened_from_pause := false

signal closed_in_pause 

func _ready():
	#set ui focus
	back_button.grab_focus()
	
	# Get audio bus indices
	master_bus_idx = AudioServer.get_bus_index("Master")
	music_bus_idx = AudioServer.get_bus_index("Music")
	sfx_bus_idx = AudioServer.get_bus_index("SFX")

	# If buses don't exist, create them
	if music_bus_idx == -1:
		music_bus_idx = AudioServer.bus_count
		AudioServer.add_bus()
		AudioServer.set_bus_name(music_bus_idx, "Music")
	else:
		print("Busses existed already, you sigma")

	if sfx_bus_idx == -1:
		sfx_bus_idx = AudioServer.bus_count
		AudioServer.add_bus()
		AudioServer.set_bus_name(sfx_bus_idx, "SFX")

	# Move click effect to SFX bus
	click_effect.bus = "SFX"

	# Connect slider drag signals
	master_volume_slider.drag_ended.connect(_on_master_volume_drag_ended)
	music_volume_slider.drag_ended.connect(_on_music_volume_drag_ended)
	sfx_volume_slider.drag_ended.connect(_on_sfx_volume_drag_ended)

	# Load saved settings
	load_settings()

	# Set panel background opacity based on how menu was opened
	if opened_from_pause:
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.05, 0.05, 0.1, 1.0)  # Same color as theme but fully opaque
		panel.add_theme_stylebox_override("panel", style)

	# Play fade in animation, or set panel to non-seethrough.
	if opened_from_pause:
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.05, 0.05, 0.1, 1.0)  # Same color as theme but fully opaque
		panel.add_theme_stylebox_override("panel", style)
	else:
		animation.play("fade_out")
		await $AnimationPlayer.animation_finished

func load_settings():
	# Load volume settings (convert from dB to slider value)
	var master_vol = db_to_slider(AudioServer.get_bus_volume_db(master_bus_idx))
	var music_vol = db_to_slider(AudioServer.get_bus_volume_db(music_bus_idx))
	var sfx_vol = db_to_slider(AudioServer.get_bus_volume_db(sfx_bus_idx))

	master_volume_slider.value = master_vol
	music_volume_slider.value = music_vol
	sfx_volume_slider.value = sfx_vol

	# Update value labels
	update_value_label(master_value_label, master_vol)
	update_value_label(music_value_label, music_vol)
	update_value_label(sfx_value_label, sfx_vol)

	# Load display settings
	var current_mode = DisplayServer.window_get_mode()
	fullscreen_checkbox.button_pressed = current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN
	vsync_checkbox.button_pressed = DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED

func update_value_label(label: Label, value: float):
	label.text = str(round(value)) + "%"

func slider_to_db(value: float) -> float:
	# Convert slider value (0-100) to decibels (-40 to 0)
	# Using a more reasonable range and exponential scaling
	if value <= 0:
		return -80.0
	return -40 + (40 * pow(value/100.0, 2))

func db_to_slider(db: float) -> float:
	# Convert decibels (-40 to 0) to slider value (0-100)
	if db <= -80:
		return 0
	if db <= -40:
		return 0
	return 100 * sqrt((db + 40) / 40)

func _on_master_volume_slider_value_changed(value: float):
	AudioServer.set_bus_volume_db(master_bus_idx, slider_to_db(value))
	update_value_label(master_value_label, value)

func _on_music_volume_slider_value_changed(value: float):
	AudioServer.set_bus_volume_db(music_bus_idx, slider_to_db(value))
	update_value_label(music_value_label, value)

func _on_sfx_volume_slider_value_changed(value: float):
	AudioServer.set_bus_volume_db(sfx_bus_idx, slider_to_db(value))
	update_value_label(sfx_value_label, value)

func _on_master_volume_drag_ended(value_changed: bool):
	if value_changed:
		click_effect.play()

func _on_music_volume_drag_ended(value_changed: bool):
	if value_changed:
		click_effect.play()

func _on_sfx_volume_drag_ended(value_changed: bool):
	if value_changed:
		click_effect.play()

func toggle_fullscreen(enable: bool) -> void:
	if enable:
		# Store current window state
		var current_pos = DisplayServer.window_get_position()
		var current_size = DisplayServer.window_get_size()

		# First, make sure we're in windowed mode
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		# Wait a frame
		await get_tree().process_frame
		# Then switch to fullscreen
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

		# Check if fullscreen was successful
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_position(current_pos)
			DisplayServer.window_set_size(current_size)
			fullscreen_checkbox.button_pressed = false
	else:
		# Switch to windowed mode
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		await get_tree().process_frame
		# Set a default window size and center it
		var screen_size = DisplayServer.screen_get_size()
		var window_size = Vector2i(1280, 720)
		var centered_position = (screen_size - window_size) / 2
		DisplayServer.window_set_size(window_size)
		DisplayServer.window_set_position(centered_position)

func _on_fullscreen_checkbox_toggled(button_pressed: bool):
	# Use deferred call to avoid window exclusivity issues
	toggle_fullscreen.call_deferred(button_pressed)
	click_effect.play()

func _on_vsync_checkbox_toggled(button_pressed: bool):
	if button_pressed:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	click_effect.play()

func _on_back_button_pressed() -> void:
	if opened_from_pause:
		click_effect.play()
		emit_signal("closed_in_pause")
		hide() #fixes flashing effect
		queue_free()
	else:
		if is_transitioning:
			return

		is_transitioning = true
		click_effect.play()
		animation.play("fade_in")
		await $AudioStreamPlayer.finished
		get_tree().change_scene_to_file("res://scenes/ui/menus/main_menu.tscn")
