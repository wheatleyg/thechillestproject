extends Enemy_attack


@export var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += speed * delta 


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
