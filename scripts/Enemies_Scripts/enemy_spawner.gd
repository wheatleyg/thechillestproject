extends Node2D

class_name EnemySpawner

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


#node stuffs
@onready var movement_timer: Timer = $MovementTimer




#node enters the scene tree for the first time.
func _ready() -> void:
	movement_timer.timeout.connect(move_enemies)
	
	
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
	add_child(enemy)
	
func move_enemies():
	position.x += ENEMY_POSITION_X_INCREMENT * movement_direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_right_wall_area_entered(area: Area2D) -> void:
	if (movement_direction == -1):
		position.y += ENEMY_POSITION_Y_INCREMENT
		movement_direction *= -1


func _on_left_wall_area_entered(area: Area2D) -> void:
	if (movement_direction == 1):
		position.y += ENEMY_POSITION_Y_INCREMENT
		movement_direction *= -1
