extends Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# translate is used to move any node using a vector as an input
	translate(Vector2(0,-1) * 1000 * delta)


func _on_visible_on_screen_notifier_2d_screen_exited():
	#deleting bullet from game
	queue_free()

# detecting what our bullet collide with
func _on_area_2d_body_entered(body):
	if body.name != player:
		# changing our bullet image into exposion
		
