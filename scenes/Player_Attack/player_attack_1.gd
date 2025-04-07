extends Player_attack


class_name player_attack_1


func _ready() -> void:
	velocity.y = -SPEED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta):
	move_and_slide()
