extends Node2D

@export var speed = 250
@export var move_down_amount = 10
var direction = Vector2(1, 0) # Initial direction: right

@onready var area_2d = $Area2D

func _ready():
	area_2d.connect("area_entered", self._on_area_entered)
	pass

func _physics_process(delta):
	position += direction * speed * delta

func _on_area_entered(area):
	# Check if the collision layer is 1
	if area.collision_layer == 1:
		move_all_down()
		reverse_direction()

func move_all_down():
	position.y += move_down_amount

func reverse_direction():
	direction.x *= -1
