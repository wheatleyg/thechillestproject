extends CharacterBody2D
class_name sheld
#Signals
signal shield_active(active: bool)


#Node references

@export var speed = 400
@onready var timer = $Timer
@onready var fading_out = false
@onready var chill_wizard = preload("uid://bm34pb8r8frsm")
@onready var _2_ndchill_wizard = preload("uid://b5ygvkf7gbnyh")


var sheild_up = false
var fade_speed = 0.1
var sheild_used = false
@onready var parent


func _ready() -> void:
	visible = false
func _physics_process(delta: float) -> void:
	
	
	
	if get_parent().name == "ChillWizard":
		parent = chill_wizard
		visible = Input.is_action_pressed("p1_shield")
		if Input.is_action_just_pressed("p1_shield"):
			if sheild_used:
				return
			fading_out = true
			sheild_up = true
			emit_signal("shield_active", !sheild_up)
		if Input.is_action_just_released("p1_shield"):
			fading_out = false
			sheild_up = false
			emit_signal("shield_active", !sheild_up)
			#parent.is_able_to_shoot = not sheild_up
		if visible :
				if fading_out and modulate.a > 0:
					modulate.a -= fade_speed * delta
					if modulate.a <= 0:
						sheild_used = true
						emit_signal("shield_active",true )
						visible = false
						fading_out = false
	elif get_parent().name == "2ndchill_wizard":
		parent = _2_ndchill_wizard
		visible = Input.is_action_pressed("p2_shield")
		if Input.is_action_just_pressed("p2_shield"):
			if sheild_used:
				return
			fading_out = true
			sheild_up = true
			emit_signal("shield_active", !sheild_up)
		if Input.is_action_just_released("p2_shield"):
			sheild_up = false
			fading_out = false
			emit_signal("shield_active", !sheild_up)
		if visible :
				if fading_out and modulate.a > 0:
					modulate.a -= fade_speed * delta
					if modulate.a <= 0:
						sheild_used = true
						emit_signal("shield_active",true )
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
				modulate.a = modulate.a / 2
		else:
			pass
 # Replace with function body.
"""
func get_input():
	var input_direction = Input.get_action_strength("p1_right") - Input.get_action_strength("p1_left") #left and Right movement
	velocity = Vector2(input_direction * speed,0)  # no vert movement

"""
	
