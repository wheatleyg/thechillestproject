extends CharacterBody2D

# Speed of the enemy
@export var speed = 500
# Amount to move downwards when bouncing
@export var move_down_amount = 50
var direction = Vector2(1,0)

@export var bounce_collision_layer = 1 # Set this to the layer you want to bounce off

@onready var area_2d = $Area2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D

func _ready():
    area_2d.connect("area_entered", self._on_area_entered)

func _physics_process(delta):
    var collision = move_and_collide(direction * speed * delta)
    if collision:
        if collision.get_collider().collision_layer & (1 << bounce_collision_layer):
            direction.x = -direction.x
            position.y += move_down_amount

func _on_area_entered(area):
    pass
