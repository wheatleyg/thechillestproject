extends Control

@onready var label: Label = $Score/Label

@onready var texture_rect_1: TextureRect = $HeartContainer/TextureRect
@onready var texture_rect_2: TextureRect = $HeartContainer/TextureRect2
@onready var texture_rect_3: TextureRect = $HeartContainer/TextureRect3

@onready var game_manager = $"../GameManager"



const HEALTH_EMPTY = preload("res://assets/sprites/health_empty.png")
const HEALTH_FULL = preload("res://assets/sprites/health_full.png")
var counter = 1
var health = 3  # Current health value

func _ready() -> void:
	if visible == false:
		show()
	
	set_anchors_preset(Control.LayoutPreset.PRESET_TOP_LEFT) #this line is only to stop 1 warning

	var viewport_size = get_viewport().get_visible_rect().size
	set_deferred("size", viewport_size)

	game_manager.on_crystals_increased.connect(update_score)

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
