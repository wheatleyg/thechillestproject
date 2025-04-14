extends Node


@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


var gun1 = preload("uid://cgfvtamd1ybis")


func _ready() -> void:
	audio_stream_player.stream = gun1
	audio_stream_player.playing = true
	audio_stream_player.play
