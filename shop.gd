extends Control

@onready var attack_up: TextureButton = $Items_Background/GridContainer/Attack_up
@onready var cystems_x_2: TextureButton = $Items_Background/GridContainer/Crystals_x2

@onready var dash: TextureButton = $Items_Background/GridContainer/Dash
@onready var defense_up: TextureButton = $Items_Background/GridContainer/Defense_up
@onready var health_up: TextureButton = $Items_Background/GridContainer/Health_up
@onready var new_a_ttack = $Items_Background/GridContainer/New_attack
@onready var score_counter: Label = $Shopkeeper_background/Score/Panel/Label

@onready var shopkeeper_speech: Label = $Shopkeeper_background/Shopkeeper_speech

var cancel_loop = false
var is_loop_running = false
var current_text_request_id = 0

var current_focused_button
var score = 1000


@export var current_purchases = {
	"Attack_up": 0,
	"Crystals_x2": 0,
	"Dash": 0,
	"Defense_up": 0,
	"Health_up": 0,
	"New_attack": 1000 #❎✅
}

func _ready():
	# Fix typo
	attack_up.grab_focus()
	#to save and keep code more organized, i'll assign all connections inside code
	update_buttons()

	# Connect specific functionality to each button
	attack_up.pressed.connect(_on_attack_up_pressed)
	cystems_x_2.pressed.connect(_on_cystems_x_2_pressed)
	dash.pressed.connect(_on_dash_pressed)
	defense_up.pressed.connect(_on_defense_up_pressed)
	health_up.pressed.connect(_on_health_up_pressed)
	new_a_ttack.pressed.connect(_on_new_attack_pressed)

# Ensure button pivot is set to center for proper scaling
func _ensure_centered_pivot(button: TextureButton) -> void:
	# Set initial pivot point
	button.pivot_offset = button.size / 2

	# Connect to resized signal to update pivot when size changes
	button.resized.connect(func():
		button.pivot_offset = button.size / 2
	)

# Handle focus changes
func _on_button_focus(button: TextureButton, is_focused: bool) -> void:
	button.modulate = Color(0.7, 0.9, 1.0, 1.0) if is_focused else Color(1.0, 1.0, 1.0, 1.0)
	current_focused_button = button

	_update_text(button.editor_description)

# Handle button click visual effects only
func _on_button_click_visual(button: TextureButton) -> void:
	# Double-check that pivot is centered before animation
	button.pivot_offset = button.size / 2

	# Apply deeper tint
	button.modulate = Color(0.4, 0.7, 1.0, 1.0)

	# Simple shrink and grow animation
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(button, "scale", Vector2(0.85, 0.85), 0.15)
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.2)

	# Reset tint when animation completes
	tween.tween_callback(func():
		button.modulate = Color(0.7, 0.9, 1.0, 1.0) if button.has_focus() else Color(1.0, 1.0, 1.0, 1.0)
	)

# Individual button functionality
func _on_attack_up_pressed() -> void:
	
	current_purchases[current_focused_button.name] += 1
	score -= 1000
	update_buttons()
	

func _on_cystems_x_2_pressed() -> void:
	current_purchases[current_focused_button.name] += 1
	score -= 1000
	update_buttons()

func _on_dash_pressed() -> void:
	current_purchases[current_focused_button.name] += 1
	score -= 1000
	update_buttons()

func _on_defense_up_pressed() -> void:
	current_purchases[current_focused_button.name] += 1
	score -= 1000
	update_buttons()

func _on_health_up_pressed() -> void:
	current_purchases[current_focused_button.name] += 1
	score -= 1000
	update_buttons()

func _on_new_attack_pressed() -> void:
	current_purchases[current_focused_button.name] += 1
	score -= 1000
	update_buttons()

func _update_text(text: String):
	# Increment request ID for this update
	current_text_request_id += 1
	var this_request_id = current_text_request_id

	# If there's an ongoing animation, cancel it
	if is_loop_running:
		cancel_loop = true
		await get_tree().process_frame

	# If this request is no longer the most recent, abort
	if this_request_id != current_text_request_id:
		return

	cancel_loop = false
	is_loop_running = true

	var print_text = ""
	for i in text.length():
		# If this request is no longer the most recent, abort
		if this_request_id != current_text_request_id:
			break

		if cancel_loop:
			break

		print_text = print_text + text[i]
		shopkeeper_speech.text = print_text
		await get_tree().create_timer(0.005).timeout

	# Only update final text if this is still the most recent request
	if this_request_id == current_text_request_id:
		shopkeeper_speech.text = text

	is_loop_running = false
	
	
func update_buttons(): #and score
	var buttons = [attack_up, cystems_x_2, dash, defense_up, health_up, new_a_ttack]

	# Setup common functionality for all buttons
	
	var padded_score = str(score).pad_zeros(5)
	score_counter.text = padded_score
	for button in buttons:
		# Ensure the pivot is set to the center after the button is fully loaded
		_ensure_centered_pivot(button)

		# Connect focus signals for visual effects
		button.focus_entered.connect(func(): _on_button_focus(button, true))
		button.focus_exited.connect(func(): _on_button_focus(button, false))

		# Visual effect on click - handled separately from functionality
		button.pressed.connect(func(): _on_button_click_visual(button))

		button.get_node("Label").text = str(current_purchases[button.name])
