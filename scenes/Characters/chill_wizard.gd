extends CharacterBody2D

@export var speed = 400

func get_input():
	var input_direction = Input.get_action_strength("p1_right") - Input.get_action_strength("p1_left") #left and Right movement
	velocity = Vector2(input_direction * speed, 0)  # no vert movement

func _physics_process(delta):
	get_input()
	move_and_slide()
