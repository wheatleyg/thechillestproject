extends Control
class_name label

@onready var My_label = $Label

func _ready():
	My_label.autowrap_mode = TextServer.AUTOWRAP_WORD
