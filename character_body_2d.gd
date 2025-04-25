extends CharacterBody2D
class_name sheld

@export var speed = 400
@onready var timer = $Timer
var sheld_ready = true
func _ready() -> void:
	visible = false
func _physics_process(delta: float) -> void:
	
	visible = Input.is_action_pressed("p1_b")
	if sheld_ready:
		use_ability()
		
func use_ability():
	if sheld_ready:
		sheld_ready = false
		timer.start()
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	if visible:
		if area.is_in_group("enemy_attacks"):
			area.queue_free()
			
 # Replace with function body.
func get_input():
	var input_direction = Input.get_action_strength("p1_right") - Input.get_action_strength("p1_left") #left and Right movement
	velocity = Vector2(input_direction * speed,0)  # no vert movement


func _on_timer_timeout() -> void:
	sheld_ready = true
	visible =false
	pass # Replace with function body.
