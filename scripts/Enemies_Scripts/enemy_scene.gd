extends Area2D

class_name Enemy

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var config: Resource


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.texture = config.sprite
	
	animation_player.play(config.animation_name)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass





func _on_body_entered(body: Node2D) -> void:
	if body is player_attack_1:
		
		animation_player.play("explosion")
	
		body.queue_free()
		await animation_player.animation_finished
	
	
		queue_free()
