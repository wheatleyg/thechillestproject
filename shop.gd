extends Control

#Node references
@onready var attack_up: TextureButton = $Items_Background/GridContainer/Attack_up
@onready var cystems_x_2: TextureButton = $Items_Background/GridContainer/Crystals_x2
@onready var back_button: Button = $Items_Background/Back_button
@onready var dash: TextureButton = $Items_Background/GridContainer/Dash
@onready var defense_up: TextureButton = $Items_Background/GridContainer/Defense_up
@onready var health_up: TextureButton = $Items_Background/GridContainer/Health_up
@onready var new_a_ttack = $Items_Background/GridContainer/New_attack
@onready var score_counter: Label = $Shopkeeper_background/Score/Panel/Label
@onready var shopkeeper_speech: Label = $Shopkeeper_background/Shopkeeper_speech
@onready var current_purchases = GameManager.power_ups

#Prices
const ATTACK_UP_PRICE = 5000
const CRYSTALS_TIMES_2_PRICE = 5000
const DASH_PRICE = 5000
const DEFENSE_UP_PRICE = 5000
const HEALTH_UP_PRICE = 5000
const NEW_ATTACK_PRICE = 5000

var cancel_loop = false
var is_loop_running = false
var current_text_request_id = 0
var current_focused_button
var score = GameManager.crystals


"""
@export var current_purchases = {
	"Attack_up": 0,
	"Crystals_x2": 0,
	"Dash": 0,
	"Defense_up": 0,
	"Health_up": 0,
	"New_attack": false #❎✅
}
"""
func _ready():
	randomize()
	# Fix typo
	back_button.grab_focus()
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

	_update_text(button.editor_description, 0)

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
	if current_purchases[current_focused_button.name] >= 3:
		_update_text("rand", 0)
		return
	elif score < ATTACK_UP_PRICE:
		_update_text("rand3", ATTACK_UP_PRICE)
		return
	current_purchases[current_focused_button.name] += 1
	score -= 1000
	update_buttons()
	

func _on_cystems_x_2_pressed() -> void:
	if current_purchases[current_focused_button.name] >= 3:
		_update_text("rand", 0)
		return
	elif score < CRYSTALS_TIMES_2_PRICE:
		_update_text("rand3", CRYSTALS_TIMES_2_PRICE)
		return
	current_purchases[current_focused_button.name] += 1
	score -= 1000
	update_buttons()
	
func _on_dash_pressed() -> void:
	if current_purchases[current_focused_button.name] >= 3:
		_update_text("rand", 0)
		return
	elif score < DASH_PRICE:
		_update_text("rand3", DASH_PRICE)
		return
		
	current_purchases[current_focused_button.name] += 1
	score -= 1000
	update_buttons()

func _on_defense_up_pressed() -> void:
	if current_purchases[current_focused_button.name] >= 3:
		_update_text("rand", 0)
		return
	elif score < DEFENSE_UP_PRICE:
		_update_text("rand3", DEFENSE_UP_PRICE)
		return
	current_purchases[current_focused_button.name] += 1
	score -= 1000
	update_buttons()

func _on_health_up_pressed() -> void:
	if current_purchases[current_focused_button.name] >= 3:
		_update_text("rand", 0)
		return
	elif score < HEALTH_UP_PRICE:
		_update_text("rand3", HEALTH_UP_PRICE)
		return
	current_purchases[current_focused_button.name] += 1
	score -= 1000
	update_buttons()

func _on_new_attack_pressed() -> void:
	if current_purchases[current_focused_button.name] == true:
		_update_text("rand_1", 0)
		return
	elif score < NEW_ATTACK_PRICE:
		_update_text("rand3", NEW_ATTACK_PRICE)
		return
	current_purchases[current_focused_button.name] = true
	score -= 1000
	update_buttons()

func _update_text(text: String, current_price: int):
	if text == "rand":
		var random_end_text = {
			1: "Can't buy anymore of that! Max is three!",
			2: "Slow down, chill guy! Max is three!",
			3: "Too much of that chill guy! You can only buy three.",
			4: "I can't let you buy anymore. The max is three.",
			5: "Chill Chill guy, you can't buy more than three."
		}
		text = random_end_text[randi_range(1, len(random_end_text))]
	elif text == "rand_1":
		var random_end_text_1 = {
			1: "You can't have more than two weapons!",
			2: "I can't let you buy any more than two.",
			3: "Too many weapons, Chill guy."
		}
		text = random_end_text_1[randi_range(1, len(random_end_text_1))]
	elif text == "rand3":
		var random_end_text_2 = {
			1: "Sorry Chill guy, you're too poor for that. (" + str(current_price) + ")",
			2: "You're too broke, Chill guy. (" + str(current_price) + ")",
			3: "You don't have enough crystals. (" + str(current_price) + ")"
		}
		text = random_end_text_2[randi_range(1, len(random_end_text_2))]
		
		
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

		if current_purchases[button.name] is bool:
			if current_purchases[button.name] == false:
				pass
			else:
				button.get_node("Label").text = "✅" 
		else:
			button.get_node("Label").text = str(current_purchases[button.name])


func _on_back_button_pressed() -> void:
	GameManager.crystals = score
	GameManager.power_ups = current_purchases
	get_tree().change_scene_to_file("res://scenes/ui/intermission_menu.tscn")
