extends Node


class_name game_manager
@export var lifes = 3


@onready var ENEMY_SPAWNER = preload("uid://ug0jvf711563")
@onready var player1 = preload("uid://bm34pb8r8frsm")

signal on_crystals_increased(crystal_count: int)
@export var power_ups = {
	"Attack_up": 0,
	"Crystals_x2": 2,
	"Dash": 0,
	"Defense_up": 0,
	"Health_up": 0,
	"New_attack": false #❎✅

}


var crystals = 0



var player1_scene = preload("res://scenes/Characters/chill_wizard.tscn")






func _ready():
	# No need to connect here since enemy_spawner connects to us
	pass



func increase_crystals(crystals_to_add: int):

	crystals = crystals + crystals_to_add
	on_crystals_increased.emit(crystals)
