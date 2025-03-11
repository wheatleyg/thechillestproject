extends CharacterBody2D

@export var speed = 500
@export var move_down_amount = 25
var direction = Vector2(1, 0) # Initial direction: right

@export var num_rows = 5
@export var num_cols = 10
@export var horizontal_spacing = 128
@export var vertical_spacing = 64
#@export var enemy_scene : PackedScene  # No longer exported

var enemy_scene : PackedScene # Declare the variable

@onready var collision_shape = $CollisionShape2D

func _ready():
    enemy_scene = load("res://scenes/Enemies_Scenes/enemy.tscn") # Load the scene
    create_enemy_grid()
    _resize_collision_shape() # Resize after creating the grid

func _physics_process(delta):
    var collision = move_and_collide(direction * speed * delta)
    if collision:
        direction.x *= -direction.x  # Reverse direction on *any* collision
        position.y += move_down_amount

func create_enemy_grid():
    # Loop through rows and columns to create the grid
    for row in num_rows:
        for col in num_cols:
            # Instantiate a new enemy from the PackedScene
            var enemy_instance = enemy_scene.instantiate()

            # Calculate the position of the enemy in the grid
            var enemy_x = col * horizontal_spacing
            var enemy_y = row * vertical_spacing

            # Set the enemy's position relative to the EnemyManager
            enemy_instance.position = Vector2(enemy_x, enemy_y)

            # Add the enemy as a child of the EnemyManager
            add_child(enemy_instance)

func _resize_collision_shape():
    # Calculate the bounding rectangle of all enemy children
    var total_rect = Rect2()
    for child in get_children():
        if child is Sprite2D:  # Or whatever the base class of your enemies is
            var child_rect = Rect2(child.position.x - child.texture.get_width() / 2, child.position.y - child.texture.get_height() / 2, child.texture.get_width(), child.texture.get_height())
            if total_rect.has_no_area():
                total_rect = child_rect
            else:
                total_rect = total_rect.merge(child_rect)

    # Update the CollisionShape2D
    if collision_shape is CollisionShape2D and collision_shape.shape is RectangleShape2D:
        collision_shape.shape.extents = total_rect.size / 2
        collision_shape.position = total_rect.get_center()
