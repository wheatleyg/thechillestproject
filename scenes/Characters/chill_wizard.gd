extends CharacterBody2D
class_name player

@export var speed = 400
@onready var main = get_tree().get_root()

@export var projectile : PackedScene
@export var projectile_2 : PackedScene
var current_projectile = true #false for projectile 1, true for projectile 2

@onready var marker_2d: Marker2D = $Marker2D

@onready var GAME_HUD = $"../../game_hud"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bullet_sound_effect_player: AudioStreamPlayer = $BulletSoundEffectPlayer
@onready var player_bullets: Node2D = $"../../BulletManager/PlayerBullets"

@onready var timer: Timer = $Timer

signal player1_died
var shots_left = 3
var shoot_effect_one = preload("uid://lq088uvjrlrj")

var rapid = false
var health = GameManager.power_ups["Health_up"]

var speedup_charges = GameManager.power_ups["Dash"]
var is_speedup_active = false

var buff_charages = GameManager.power_ups["Attack_up"]
var is_buff_active = false
var DEBUG = GameManager.DEBUGMODE #TURN OFF WHEN TURNING IN

func get_input():
	var input_direction = Input.get_action_strength("p1_move_right") - Input.get_action_strength("p1_move_left") #left and Right movement
	velocity = Vector2(input_direction * speed,0)  # no vert movement

	if Input.is_action_just_pressed("p1_shoot"):
		shoot()

	#if Input.is_a`tion_just_pressed("p1_shoot_up"):
		#rapid = true
	elif Input.is_action_just_pressed("p1_special"): # J
		buff_up()

	elif Input.is_action_just_pressed("p1_shoot_up"):
		speed_up()
	
	elif GameManager.power_ups["New_attack"] == true:
		if Input.is_action_just_pressed("p1_switch_weapon"):
			current_projectile = !current_projectile
	else:
		pass



func _physics_process(_delta):
	if DEBUG:
		shoot()
	move_and_slide()
	if rapid == true:
		shoot()
	get_input()


func shoot():
	#health_manager(-1)
	
	
	
	if timer.is_stopped():
		shots_left = GameManager.shots_left_for_each
		timer.start()
		if current_projectile == false: #projectile 1
			var bullet = projectile.instantiate()
			bullet.global_position = marker_2d.global_position
			bullet.rotation = global_rotation
			player_bullets.add_child(bullet)
			bullet_sound_effect_player.stream = shoot_effect_one
			bullet_sound_effect_player.play()
		elif current_projectile == true: #projectile 2
			if shots_left <= 0:
				return
			else:
				shots_left = shots_left - 1
				GameManager.shots_left_for_each = shots_left
				GAME_HUD.update_bullets(shots_left)
			print(str(shots_left))
			
			var bullet = projectile_2.instantiate()
			bullet.global_position = marker_2d.global_position
			bullet.rotation = global_rotation
			player_bullets.add_child(bullet)
			bullet_sound_effect_player.stream = shoot_effect_one
			bullet_sound_effect_player.play()
	else:
		pass
func health_manager(change: int):
	health = GameManager.power_ups["Health_up"]  # Get current health from GameManager
	health = health + change
	health = max(0, health)
	GAME_HUD.set_health(health)
	GameManager.power_ups["Health_up"] = health
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
	buff_charages = GameManager.power_ups["Attack_up"]

	if is_buff_active == true:
		pass
	else:
		if buff_charages <= 0:
			return
		else:
			buff_charages -= 1
			GameManager.power_ups["Attack_up"] = buff_charages
			is_buff_active = true
			timer.wait_time = timer.wait_time / 2
			await get_tree().create_timer(8.00).timeout
			timer.wait_time = timer.wait_time * 2
			is_buff_active = false





func speed_up():
	speedup_charges = GameManager.power_ups["Dash"]
	if is_speedup_active == true:
		print(" speedup is already active, skipping.")
		return
	else:
		if speedup_charges <= 0:
			return
		else:
			speedup_charges -= 1
			GameManager.power_ups["Dash"] = speedup_charges
			is_speedup_active = true
			speed = speed * 2
			await get_tree().create_timer(10.00).timeout
			speed = speed / 2
			is_speedup_active = false
