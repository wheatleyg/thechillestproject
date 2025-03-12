extends Node2D

class_name EnemySpawner

#config for the spawner

const ROWS = 5
const COLUMNS = 11
const HORIZONTAL_SPACING = 32
const VERTICAL_SPACING = 32
const ENEMY_HEIGHT = 24
const START_Y_POSITION = -50
const ENEMY_POSITION_X_INCREMENT = 10
const ENEMY_POSITION_Y_INCREMENT = 20

var movement_direction = 1

var enemy_scene = preload("res://scenes/Enemies_Scenes/enemy_scene.tscn")

#node enters the scene tree for the first time.
func _ready() -> void:
	var enemy_1_res = preload("res://resources/enemy_1.tres")
	#var enemy_2_res
	#var enemy_3_res
	
	var enemy_config
	
	for row in ROWS:
		if row == 0:
			enemy_config = enemy_1_res
		elif row == 1 || row == 2:
			enemy_config = enemy_1_res
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
	var enemy = enemy_scene.instantiate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
