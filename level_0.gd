extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_cleanup_body_entered(body: Node2D) -> void:
	print("Entered:", body.name, " | Scene Path:", body.scene_file_path, " | Type:", body.get_class())
	if body.scene_file_path == "res://Player_Attack/player_attack_1.tscn":
		print("it's a bullet")
		body.queue_free()
