extends Control
#onready
@onready var timer: Timer = $Timer
@onready var spot_1: Label = %spot1
@onready var spot_2: Label = $Panel/GridContainer/spot2
@onready var spot_3: Label = $"Panel/GridContainer/spot 3"



var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var curr_spot = 0
var flash = false
var curr_name = ['_', '_', '_']

var spot_array = []

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
		if curr_spot >= 4:
			curr_spot = 1
		else:
			curr_spot += 1

func _on_timer_timeout() -> void:
	if flash: #true
		flash = !flash
		spot_array[curr_spot].modulate = Color8(255,255,255,127)
	else: 
		flash = !flash
		spot_array[curr_spot].modulate = Color8(255,255,255,255)
	timer.start()
	
	
	
func _process(_delta: float) -> void:
	pass
	
func spot_manager():
	var past_spot
	
	spot_array[curr_spot].modulate = Color8(255,255,255,255) 
	if curr_spot >= 3:
		curr_spot = 0
	else:
		curr_spot = curr_spot + 1 
	
	
