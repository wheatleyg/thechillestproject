extends Control

#declare nodes
@onready var timer: Timer = $Timer

@onready var spot_1: Label = %spot1
@onready var spot_2: Label = $Panel/GridContainer/spot2
@onready var spot_3: Label = $"Panel/GridContainer/spot 3"


var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var current_letter_index = 0
var current_spot = 0
var is_spot_visible = true
var spots = []

func _ready() -> void:
	spots = [spot_1, spot_2, spot_3]
	# Initialize all spots with underscores
	for spot in spots:
		spot.text = "_"
	
	# Set up timer for flashing effect
	timer.wait_time = 0.5
	timer.connect("timeout", _on_timer_timeout)
	timer.start()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Cycle through alphabet
			current_letter_index = (current_letter_index + 1) % alphabet.length()
			spots[current_spot].text = alphabet[current_letter_index]
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			# Move to next spot
			if current_spot < 2:
				spots[current_spot].text = alphabet[current_letter_index]
				current_spot += 1
				current_letter_index = 0
				is_spot_visible = true

func _on_timer_timeout() -> void:
	is_spot_visible = !is_spot_visible
	if is_spot_visible:
		spots[current_spot].text = alphabet[current_letter_index]
	else:
		spots[current_spot].text = "_"

func get_final_name() -> String:
	var name = ""
	for spot in spots:
		name += spot.text
	return name

func _process(_delta: float) -> void:
	pass
