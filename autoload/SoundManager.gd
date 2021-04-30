extends Node

var sfx_pool := []
var ui_sfx := AudioStreamPlayer.new() setget ,getUIAudioPlayer

var sound_idx := 0

func _ready() -> void:
	for i in range(20):
		var p := AudioStreamPlayer.new()
		sfx_pool.append(p)

func getAudioPlayer() -> AudioStreamPlayer:
	var stream = sfx_pool[sound_idx]

	while(stream.playing):
		sound_idx = wrapi(sound_idx + 1, 0, sfx_pool.size())
		stream = sfx_pool[sound_idx]
		print_debug("audio player #%s" % str(sound_idx))

	return stream

func getUIAudioPlayer() -> AudioStreamPlayer:
	return ui_sfx
