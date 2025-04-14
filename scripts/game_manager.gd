extends Node


class_name game_manager

signal on_crystals_increased(crystal_count: int)

var crystals = 0
var player1_scene = preload("res://scenes/Characters/chill_wizard.tscn")

@export var lifes = 3


@onready var ENEMY_SPAWNER = $"../enemy_spawner"
@onready var player1 = $"../PlayerManager/ChillWizard"





func _ready():
	ENEMY_SPAWNER.enemy_destroyed.connect(increase_crystals)



func increase_crystals(crystals_to_add: int):
	
	crystals = crystals + crystals_to_add
	on_crystals_increased.emit(crystals)
