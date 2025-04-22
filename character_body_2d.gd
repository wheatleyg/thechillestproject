extends CharacterBody2D
class_name sheld

func _physics_process(delta: float) -> void:
	visible = false
	if Input.is_action_just_pressed("p1_b"):
		visible = true
	if visible == true:
		if body(Enemy_attack)

func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
