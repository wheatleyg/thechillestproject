extends Node2D

class_name EnemySpawner


signal enemy_destroyed(crystals: int)
signal level_complete
signal level_failed

#config for the spawner

const ROWS = 5
const COLUMNS = 11
const HORIZONTAL_SPACING = 88
const VERTICAL_SPACING = 32
const ENEMY_HEIGHT = 56
const START_Y_POSITION = -50
const ENEMY_POSITION_X_INCREMENT = 30
const ENEMY_POSITION_Y_INCREMENT = 20

var movement_direction = 1


var enemy_scene = preload("res://scenes/Enemies_Scenes/enemy_scene.tscn")

var total_enemy_destroyed = 0
var enemy_total_count = ROWS * COLUMNS
var spawned_enemies = []  # Track spawned enemies to prevent double counting

#node stuffs
@onready var movement_timer: Timer = $MovementTimer
@onready var shoot_timer: Timer = $ShootTimer
@onready var enemy_bullets: Node2D = $"../BulletManager/EnemyBullets"

var count = 0

#node enters the scene tree for the first time.
func _ready() -> void:
	# Connect to the GameManager autoload
	"""
	var GameManager #= get_node("/root/GameManager")
	if GameManager:
		self.enemy_destroyed.connect(GameManager.increase_crystals)
	else:
		push_error("GameManager autoload not found!")
	"""

	self.enemy_destroyed.connect(GameManager.increase_crystals)
	
	self.level_complete.connect(GameManager._switch_levels)

	movement_timer.timeout.connect(move_enemies)
	shoot_timer.timeout.connect(on_enemy_shoot)

	# Reset counters
	total_enemy_destroyed = 0
	spawned_enemies.clear()

	spawn_enemies()

func spawn_enemies():
	var enemy_1_res = preload("uid://eswdgxaofm4g")
	var enemy_2_res = preload("uid://cvb1x5l5grhq7")
	var enemy_3_res = preload("uid://b7tjv2ly54mcr")

	var enemy_config

	for row in ROWS:
		if row == 0:
			enemy_config = enemy_3_res
		elif row == 1 || row == 2:
			enemy_config = enemy_2_res
		elif row == 3 || row == 4:
			enemy_config = enemy_1_res

		var row_width = (COLUMNS * enemy_config.width * 3) + ((COLUMNS -1) * HORIZONTAL_SPACING)
		var start_x = (position.x - row_width) / 2

		for col in COLUMNS:
			var x = start_x + (col * enemy_config.width * 3) + (col * HORIZONTAL_SPACING)
			var y = START_Y_POSITION + (row * ENEMY_HEIGHT) + (row * VERTICAL_SPACING)
			var spawn_position = Vector2(x, y)

			spawn_enemy(enemy_config, spawn_position)

func spawn_enemy(enemy_config, spawn_position: Vector2):
	var enemy = enemy_scene.instantiate() as Enemy
	enemy.config = enemy_config
	enemy.global_position = spawn_position
	enemy.enemy_destroyed.connect(on_enemy_destroyed)
	add_child(enemy)
	spawned_enemies.append(enemy)
	print("Spawning enemy. Total spawned: " + str(spawned_enemies.size()))

func move_enemies():
	position.x += ENEMY_POSITION_X_INCREMENT * movement_direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_right_wall_area_entered(_area: Area2D) -> void:
	if (movement_direction == -1):
		position.y += ENEMY_POSITION_Y_INCREMENT
		movement_direction *= -1


func _on_left_wall_area_entered(_area: Area2D) -> void:
	if (movement_direction == 1):
		position.y += ENEMY_POSITION_Y_INCREMENT
		movement_direction *= -1


func on_enemy_shoot():
	var enemies = get_children().filter(func (child): return child is Enemy)
	if enemies.size() > 0:
		# Create a weighted list of enemies based on their shoot probabilities
		var weighted_enemies = []
		for enemy in enemies:
			# Add the enemy multiple times based on its probability
			var weight = int(enemy.config.shoot_probability * 10)  # Convert probability to a weight (0-10)
			for i in range(weight):
				weighted_enemies.append(enemy)

		if weighted_enemies.size() > 0:
			var selected_enemy = weighted_enemies.pick_random()
			var enemy_shoot = selected_enemy.config.attack_scene.instantiate()
			if enemy_shoot is Enemy_attack:
				enemy_bullets.add_child(enemy_shoot)
				enemy_shoot.global_position = selected_enemy.global_position

func on_enemy_destroyed(crystalsvalue: int, enemy: Enemy):
	# Remove the enemy from our tracking list
	if enemy in spawned_enemies:
		spawned_enemies.erase(enemy)
		total_enemy_destroyed += 1
		enemy_destroyed.emit(crystalsvalue)
		print("Enemy destroyed. Remaining: " + str(spawned_enemies.size()) + "/" + str(enemy_total_count))

		if total_enemy_destroyed >= enemy_total_count:
			print("All enemies destroyed!")
			level_complete.emit()
			await get_tree().create_timer(3.00).timeout
			get_tree().change_scene_to_file("res://scenes/ui/intermission_menu.tscn")
			
