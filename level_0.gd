extends Node2D
var updated = false
var level = 2
var levelres = {
	1: preload("uid://b54yt6vqmukml"),
	2: preload("uid://beum8s8xne2v1"),
	3: preload("uid://cyuk5sfx1a0ao")
	}
@onready var background: Sprite2D = $Enviroment/Background
@onready var foreground: Sprite2D = $Enviroment/Foreground




# Called when the node enters the scene tree for the first time.
func _onready() -> void:
	updated = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not updated:
		if levelres.has(level):
			var resource = levelres[level]
			background.texture = resource.background
			background.scale = resource.scale
			if resource.position_x == 0:
				pass
			else:
				background.position.x = resource.position_x
				background.position.y = resource.position_y
			updated = true
	else:
		pass
		
