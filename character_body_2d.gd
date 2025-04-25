extends CharacterBody2D
class_name sheld

@export var speed = 400
func _ready() -> void:
	visible = false
func _physics_process(delta: float) -> void:
	
	visible = Input.is_action_pressed("p1_b")
	
	"""
	if Input.is_action_just_pressed("p1_b"):
		visible = true
	if Input.is_action_just_released("p1_b"):
		visible = false
"""

func _on_area_2d_area_entered(area: Area2D) -> void:
	if visible:
		if area.is_in_group("enemy_attacks"):
			area.queue_free()
 # Replace with function body.
func get_input():
	var input_direction = Input.get_action_strength("p1_right") - Input.get_action_strength("p1_left") #left and Right movement
	velocity = Vector2(input_direction * speed,0)  # no vert movement
