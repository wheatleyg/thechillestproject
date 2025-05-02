extends Player_attack

var speed = 2000

func _ready() -> void:
	velocity.y = -speed
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	move_and_slide()
