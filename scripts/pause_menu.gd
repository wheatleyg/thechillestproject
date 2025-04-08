extends Control

@onready var timer: Timer = $Timer
@onready var flashing_labels: Control = $Panel/FlashingLabels


var time := 0.0
var speed := 0.7 # Controls how fast the fade happens
var is_showing := false
var transitioning := false
var tween

func _ready():

	set_anchors_preset(Control.LayoutPreset.PRESET_TOP_LEFT) #this line is only to stop 1 warning
	
	var viewport_size = get_viewport().get_visible_rect().size
	set_deferred("size", viewport_size)
	modulate.a = 0.0

func _process(delta):
	time += delta * speed
	# Sine wave goes from 0 to 1 smoothly
	var alpha = (sin(time * PI * 2) + 1.0) / 2.0
	flashing_labels.modulate.a = alpha
	
	
	if Input.is_action_just_pressed("quit"):
		toggle_transition()
	
	
func toggle_transition():
	if transitioning:
		return  # dont allow toggle while fading
	if is_showing:
		get_tree().paused = false
		fade_out()
	else:
		get_tree().paused = true
		fade_in()



func fade_in():
	
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
	

func _on_fade_complete():
	transitioning = false
