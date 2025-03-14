extends Area2D

class_name Enemy

@onready var sprite_2d: Sprite2D = $Sprite2D

var config: Resource


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.texture = config.sprite


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
