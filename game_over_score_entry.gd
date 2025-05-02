extends Control
#onready
@onready var timer: Timer = $Timer
@onready var spot_1: Label = %spot1
@onready var spot_2: Label = $Panel/GridContainer/spot2
@onready var spot_3: Label = $"Panel/GridContainer/spot 3"



var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var max_letters = len(alphabet)
var current_letter = 0
var curr_spot = 0
var flash = false
var curr_name = ['_', '_', '_']

var updated = false


var curr_name_index =  [0, 0, 0]


var alphebet_index = 0
var spot_array = []
var spot_updated = false
var opaque = Color8(255,255,255,255)
var half_opaque = Color8(255,255,255,127)


func _ready() -> void:
	spot_array = [
		spot_1,
		spot_2,
		spot_3
	]
	
	
	


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("p1_l1"): #U
		spot_manager()
	elif event.is_action_pressed("p1_a"): # H
		_one_key_keyboard()
	
func spot_manager():
	
	spot_array[curr_spot].modulate = opaque
	

	curr_spot = curr_spot + 1 
	
	if curr_spot >= 3:
		curr_spot = 0
	save_name()
	spot_updated = false
	spot_array[curr_spot].modulate = half_opaque
	flash = true
	timer.start()
	_on_timer_timeout()
	
	
func _on_timer_timeout() -> void:
	if flash: #true
		flash = !flash
		spot_array[curr_spot].modulate = half_opaque
	else: 
		flash = !flash #false
		spot_array[curr_spot].modulate = opaque
	timer.start()
	
	
	
	
func _one_key_keyboard():
	"""
	if spot_updated == false:
		
		var current_char = curr_name[curr_spot]
		if current_char == '_':
			alphebet_index = 0
		else:
			alphebet_index = alphabet.find(current_char)
		print(str(alphebet_index))
		
		current_letter = alphebet_index
		spot_updated = true
	else:
		pass
	spot_array[curr_spot].text = str(alphabet[current_letter])
	current_letter += 1
	if current_letter >= 26:
		current_letter = 0
	"""
	if spot_updated  == false:
		current_letter = curr_name_index[curr_spot]
		spot_updated = true
	else:
		pass
	
	spot_array[curr_spot].text = str(alphabet[current_letter])
	current_letter += 1
	print(str(current_letter))
	if current_letter >= 26:
		current_letter = 0
	
	
	
	
func _process(_delta: float) -> void:
	pass
	
	
func save_name():
	curr_name_index[curr_spot] = current_letter #saves the index of the current name to the current letter before switching
	curr_name[curr_spot] = alphabet[current_letter]
	current_letter = 0 
	for i in curr_name_index:
		
		print("current number: " + str(i) + " is " + str(current_letter[i])) 
	
	
