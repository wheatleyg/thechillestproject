extends CharacterBody2D

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
	#move_and_slide()
















#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0


#func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	#move_and_slide()
