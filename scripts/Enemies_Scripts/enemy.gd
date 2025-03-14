extends CharacterBody2D
# health of enemy
var health = 100
# size of the screen
var width = 0
# direction of movment ( -1 means left direction)
var direction = -1

func _ready():
	# start shooting after two seconds
	$Timer.start(2.0)
	# getting the width of the screen
	width = get_viewport().size.x

func _physics_process(delta):
	# when we reach the right side of the screen
	if position.x > width - 50:
		# setting direction to left 
		direction = -1
		# crating tween
		var tween = get_tree().create_tween()
		# moving enemy down or close to he player
		tween.tween_property(self, "position:y", position.y + 100, 1.0)
	
	# when we reach the left side of the screen
	elif position.x < 52:
		# setting direction to right
		direction = 1
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position:y", position.y + 100,1.0)
	
	# moving left or right
	velocity.x = direction * 20000 * delta
	move_and_slide()
	#bullet enter area
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is bullet:
		health -= 50
		print("HIT")
		if health <= 0 :
			queue_free()
	pass # Replace with function body.
