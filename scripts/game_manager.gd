extends Node


class_name game_manager
@export var lifes = 3


@onready var ENEMY_SPAWNER = preload("uid://ug0jvf711563")
@onready var player1 = preload("uid://bm34pb8r8frsm")

signal on_crystals_increased(crystal_count: int)
@export var power_ups = {
	"Attack_up": 0,
	"Crystals_x2": 0,
	"Dash": 0,
	"Defense_up": 0,
	"Health_up": 0,
	"New_attack": false #❎✅

}

var total_crystals = 0
var crystals = 0
var levels_passed = 0
var current_level = 1


var DEBUGMODE = false



var player1_scene = preload("res://scenes/Characters/chill_wizard.tscn")






func _ready():
	# No need to connect here since enemy_spawner connects to us
	pass

func _switch_levels():
	levels_passed += 1
	if current_level >= 6:
		current_level = 0
	else:
		current_level += 1

func increase_crystals(crystals_to_add: int):
	print("enemy destroyed, detected by gamemanager.")

	crystals = crystals + crystals_to_add
	total_crystals = total_crystals + crystals_to_add
	on_crystals_increased.emit(crystals)


func _reset():
	lifes = 3
	total_crystals = 0
	crystals = 0
	levels_passed = 0
	current_level = 1
	power_ups = {
	"Attack_up": 0,
	"Crystals_x2": 0,
	"Dash": 0,
	"Defense_up": 0,
	"Health_up": 0,
	"New_attack": false #❎✅
	}
