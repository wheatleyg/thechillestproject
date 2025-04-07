extends Control

@onready var label: Label = $Panel/Label
@onready var timer: Timer = $Timer

var time := 0.0
var speed := 1.0 # Controls how fast the fade happens



func _ready():
	hide()

func _process(delta):
	time += delta * speed
	# Sine wave goes from 0 to 1 smoothly
	var alpha = (sin(time * PI * 2) + 1.0) / 2.0
	label.modulate.a = alpha
	
	
	if Input.is_action_just_pressed("quit"):
		toggle_pause()
	
	

func toggle_pause():
	if get_tree().paused:
		get_tree().paused = false
		hide()
	else:
		get_tree().paused = true
		show()
