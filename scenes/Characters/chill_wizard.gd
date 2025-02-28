extends CharacterBody2D
class_name player
@export var speed = 400
@onready var main = get_tree().get_root()
@export var projectile : PackedScene
func get_input():
	var input_direction = Input.get_action_strength("p1_right") - Input.get_action_strength("p1_left") #left and Right movement
	velocity = Vector2(input_direction * speed,0)  # no vert movement

	if Input.is_action_just_pressed("p1_a"):
		shoot()
		

func _physics_process(delta):
	get_input()
	move_and_slide()
	

func shoot():
	var bullet = projectile.instantiate()
	bullet.global_position = global_position
	bullet.rotation = global_rotation
	get_parent().add_child(bullet)
 


	
