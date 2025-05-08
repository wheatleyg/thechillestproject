extends CharacterBody2D
class_name player

@export var speed = 400
@onready var main = get_tree().get_root()

@export var projectile : PackedScene
@export var projectile_2 : PackedScene
var current_projectile = 0

@onready var marker_2d: Marker2D = $Marker2D

@onready var GAME_HUD = $"../../game_hud"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bullet_sound_effect_player: AudioStreamPlayer = $BulletSoundEffectPlayer
@onready var player_bullets: Node2D = $"../../BulletManager/PlayerBullets"
@onready var timer: Timer = $Timer

signal player1_died

var shoot_effect_one = preload("uid://lq088uvjrlrj")

var rapid = false
var health = 3

var is_speedup_active = false

var is_buff_active = false
var DEBUG_SHOOT = true #TURN OFF WHEN TURNING IN

func get_input():
	var input_direction = Input.get_action_strength("p1_right") - Input.get_action_strength("p1_left") #left and Right movement
	velocity = Vector2(input_direction * speed,0)  # no vert movement

	if Input.is_action_just_pressed("p1_a"):
		shoot(false)
	if Input.is_action_just_pressed("p1_b"):
		rapid = true
	if Input.is_action_just_pressed("p1_l2"): # J 
		buff_up()

	if Input.is_action_just_pressed("p1_r2"):
		speed_up()


func _physics_process(_delta):
	if DEBUG_SHOOT:
		shoot(true)
	move_and_slide()
	if rapid == true:
		shoot(true)
	get_input()


func shoot(bypass: bool):
	#health_manager(-1)
	if timer.is_stopped() and not bypass:
		timer.start()
		var bullet = projectile.instantiate()
		bullet.global_position = marker_2d.global_position
		bullet.rotation = global_rotation
		player_bullets.add_child(bullet)

		bullet_sound_effect_player.stream = shoot_effect_one
		bullet_sound_effect_player.play()
	elif bypass:
		var bullet = projectile.instantiate()
		bullet.global_position = marker_2d.global_position
		bullet.rotation = global_rotation
		player_bullets.add_child(bullet)

		bullet_sound_effect_player.stream = shoot_effect_one
		bullet_sound_effect_player.play()
	else:
		pass
func health_manager(change: int):
	health = health + change
	health = max(0, health)
	GAME_HUD.set_health(health)
	if health <= 0:
		print("player died")
		player1_died.emit()





func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_attacks"):
		if animation_player.is_playing():
			pass
		else:
			animation_player.play("on_hit")
			health_manager(-1)
		#sigma
		area.queue_free()


func buff_up():

	if is_buff_active == true:
		pass
	else:
		is_buff_active = true
		timer.wait_time = timer.wait_time / 9999
	
		print(str(float(timer.wait_time)))
		


func speed_up():
	if is_speedup_active == true:
		print(" speedup is already active, skipping.")
		pass
	else:
		is_speedup_active = true
		speed = speed * 2
