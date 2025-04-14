extends CharacterBody2D
class_name player

@export var speed = 400
@onready var main = get_tree().get_root()
@export var projectile : PackedScene
@onready var marker_2d: Marker2D = $Marker2D

@onready var GAME_HUD = $"../../game_hud"

var rapid = false
var health = 3





func get_input():
	var input_direction = Input.get_action_strength("p1_right") - Input.get_action_strength("p1_left") #left and Right movement
	velocity = Vector2(input_direction * speed,0)  # no vert movement

	if Input.is_action_just_pressed("p1_a"):
		shoot()
	if Input.is_action_just_pressed("p2_b"):
		rapid = true


func _physics_process(_delta):
	move_and_slide()
	if rapid == true:
		shoot()
	get_input()


func shoot():
	health_manager(-1)

	var bullet = projectile.instantiate()
	bullet.global_position = marker_2d.global_position
	bullet.rotation = global_rotation
	get_parent().add_child(bullet)

func health_manager(change: int):
	health = health + change
	health = max(0, health)
	GAME_HUD.set_health(health)
