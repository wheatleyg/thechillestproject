extends Player_attack



var charges = 3

func _ready() -> void:
	velocity.y = -SPEED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _physics_process(_delta):
	move_and_slide()
	
	
	
func _shoot_thing():
	charges = charges - 1
	if charges <= 0:
		queue_free()
