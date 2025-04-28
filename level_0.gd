extends Node2D



#TODO:  gfghdfhdfh
#HACK 
#FIXME 




var updated = false
var curLevel = 2
var difficulty = 1

var levelres = { #dictionary for each level .tres file
	1: preload("uid://b54yt6vqmukml"),
	2: preload("uid://beum8s8xne2v1"),
	3: preload("uid://cyuk5sfx1a0ao"),
	4: preload("uid://b13se865de57m"),
	5: preload("uid://brp6ifuylk151"),
	6: preload("uid://cmoj884n60m36")
	}
@onready var background: Sprite2D = $Enviroment/Background
@onready var foreground: Sprite2D = $Enviroment/Foreground





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updated = false
	

	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#get_input()
	
	
	
	
	if not updated:
		if levelres.has(curLevel):
			var resource = levelres[curLevel]    #if statements for setting background and positions
			background.texture = resource.background
			
			background.scale = resource.scale
			if resource.positions.x and resource.positions.y == 0:
				pass
			else:
				background.position = resource.positions
			
			if resource.foreground == null or resource.foreground is PlaceholderTexture2D: #if statement for setting foreground
				foreground.visible = false
			else:
				foreground.texture = resource.foreground
				foreground.visible = true
			
				
			updated = true
			print("this should only show up once")
	else:
		pass
		
"""
func get_input():
	if Input.is_action_just_pressed("p1_a"):
		updated = false
		if curLevel <= 6:
			curLevel = curLevel +1
		else:
			curLevel = 1
		print("updated")

"""
func _on_cleanup_body_entered(body: Node2D) -> void:
	body.queue_free()
	
 
