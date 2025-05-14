extends CharacterBody2D
class_name sheld

@export var speed = 400
@onready var timer = $Timer
@onready var fading_out = false
var fade_speed = 0.01
func _ready() -> void:
	visible = false
func _physics_process(delta: float) -> void:
	
	
	if get_parent().name == "ChillWizard":
		visible = Input.is_action_pressed("p1_shield")
		if Input.is_action_just_pressed("p1_shield"):
			fading_out = true
		if Input.is_action_just_released("p1_shield"):
			fading_out = false
		if visible :
				if fading_out and modulate.a > 0:
					modulate.a -= fade_speed * delta
					if modulate.a <= 0:
						visible = false
						fading_out = false
	elif get_parent().name == "2ndchill_wizard":
		visible = Input.is_action_pressed("p2_shield")
		if Input.is_action_just_pressed("p2_shield"):
			fading_out = true
		if Input.is_action_just_released("p2_shield"):
			fading_out = false
		if visible :
				if fading_out and modulate.a > 0:
					modulate.a -= fade_speed * delta
					if modulate.a <= 0:
						visible = false
						fading_out = false
	"""
	visible = Input.is_action_pressed("p1_shield")
	if Input.is_action_just_pressed("p1_shield"):
		fading_out = true
	if Input.is_action_just_released("p1_shield"):
		fading_out = false
	if visible :
			if fading_out and modulate.a > 0:
				modulate.a -= fade_speed * delta
				if modulate.a <= 0:
					visible = false
					fading_out = false
"""
func _on_area_2d_area_entered(area: Area2D) -> void:
	if visible:
		if modulate.a >= 0:
			if area.is_in_group("enemy_attacks"):
				area.queue_free()
		else:
			pass
 # Replace with function body.
"""
func get_input():
	var input_direction = Input.get_action_strength("p1_right") - Input.get_action_strength("p1_left") #left and Right movement
	velocity = Vector2(input_direction * speed,0)  # no vert movement

"""
	
