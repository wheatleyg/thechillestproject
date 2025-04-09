extends CharacterBody2D
class_name player
@export var speed = 400
@onready var main = get_tree().get_root()
@export var projectile : PackedScene
@onready var marker_2d: Marker2D = $Marker2D
var rapid = false




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
	var bullet = projectile.instantiate()
	bullet.global_position = marker_2d.global_position
	bullet.rotation = global_rotation
	get_parent().add_child(bullet)
	audio_stream_player.stream = gun1
	audio_stream_player.playing = true
	
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
	
var gun1 = preload("res://assets/audio/SFX/mixkit-game-gun-shot-1662.mp3")
	
func ready() -> void:
	pass
	
