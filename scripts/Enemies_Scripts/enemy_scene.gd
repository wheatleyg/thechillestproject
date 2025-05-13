extends Area2D

class_name Enemy


signal enemy_destroyed(crystalsworth: int, enemy: Enemy)

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var config: Resource


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.texture = config.sprite
	animation_player.play(config.animation_name)
	# Remove direct connection to GameManager since enemy_spawner handles this



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass





func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_attacks"):
		if "Player_attack_1" in body.name:
			animation_player.play("explosion")
			print("enemy died, detected by scene")
			enemy_destroyed.emit(config.crystals_worth, self)
			body.queue_free()
			await animation_player.animation_finished
			queue_free()
		elif "Player_attack_2" in body.name:
			body._shoot_thing()
			animation_player.play("explosion")
			print("enemy died, detected by scene")
			enemy_destroyed.emit(config.crystals_worth, self)
			#body.queue_free()
			await animation_player.animation_finished
			queue_free()
			
		
