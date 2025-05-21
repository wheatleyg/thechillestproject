extends Control

@onready var label: Label = $Score/Label

@onready var texture_rect_1: TextureRect = $HeartContainer/TextureRect
@onready var texture_rect_2: TextureRect = $HeartContainer/TextureRect2
@onready var texture_rect_3: TextureRect = $HeartContainer/TextureRect3

@onready var game_manager = $"../GameManager"
@onready var bullets_left: Control = $BulletsLeft
@onready var bullets_left_label: Label = $BulletsLeft/GridContainer/Label
@onready var special_attack_texture = $BulletsLeft/GridContainer/Label/TextureRect
@onready var normal_attack_texture: TextureRect = $BulletsLeft/GridContainer/Label/TextureRect2


const HEALTH_EMPTY = preload("res://assets/sprites/health_empty.png")
const HEALTH_FULL = preload("res://assets/sprites/health_full.png")


var counter = 1
var health = GameManager.power_ups["Health_up"]  # Current health value

func _ready() -> void:
	
	
	var is_second_attack = GameManager.power_ups["New_attack"]
	if is_second_attack == false:
		bullets_left.hide()
	else:
		pass
	
		
	if visible == false:
		show()

	set_anchors_preset(Control.LayoutPreset.PRESET_TOP_LEFT) #this line is only to stop 1 warning

	var viewport_size = get_viewport().get_visible_rect().size
	set_deferred("size", viewport_size)

	GameManager.on_crystals_increased.connect(update_score)
	

	update_hearts()
	update_score(GameManager.crystals)

func update_hearts():
	# Update each heart based on current health
	texture_rect_1.texture = HEALTH_FULL if health >= 1 else HEALTH_EMPTY
	texture_rect_2.texture = HEALTH_FULL if health >= 2 else HEALTH_EMPTY
	texture_rect_3.texture = HEALTH_FULL if health >= 3 else HEALTH_EMPTY

func set_health(new_health: int):
	health = clamp(new_health, 0, 3)  # Ensure health stays between 0 and 3
	update_hearts()

func _physics_process(delta: float) -> void:
	#counter += 1
	#var padded_score = str(counter).pad_zeros(5)
	#label.text = padded_score
	pass

func update_score(new_score: int):

	var padded_score = str(new_score).pad_zeros(5)
	label.text = padded_score



func update_bullets(remaining: int, bulletype: bool):
	print("updating bullets!")
	if bulletype == false: #normal attack
		bullets_left_label.text = "∞"
		special_attack_texture.visible = false
		normal_attack_texture.visible = true
	elif bulletype == true:
		bullets_left_label.text = "x " + str(remaining)
		special_attack_texture.visible = true
		normal_attack_texture.visible = false
	else:
		push_error("you broke the game, stop messing with my code")
	
