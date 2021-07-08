extends Node

const SFX = {
	"machine_gun": preload("res://sprites/sfx/mg01.wav"),
	"robot_explode": preload("res://sprites/sfx/exp01.wav"),
	"robot_done": preload("res://sprites/sfx/ui_cmplt.wav")
}

var streams := []
var ui_sfx := AudioStreamPlayer.new() setget ,getUIAudioPlayer
var sound_idx := 0
var last_played := ""
var last_played_ms := 0.0

func _ready() -> void:
	for i in range(50):
		var p := AudioStreamPlayer.new()
		streams.append(p)
		add_child(p)

func getAudioPlayer() -> AudioStreamPlayer:
	var stream = streams[sound_idx]

	if stream.playing:
		sound_idx = wrapi(sound_idx + 1, 0, streams.size())
		return streams[sound_idx]

	return stream

func getUIAudioPlayer() -> AudioStreamPlayer:
	return ui_sfx

func play_sfx(sfx_name : String, pitch = 1.0, db = 1.0) -> void:
	var diff := OS.get_ticks_msec() - last_played_ms

	if sfx_name.is_subsequence_ofi(last_played) && diff < 40:
		return
	else:
		last_played = sfx_name

	var player = SoundManager.getAudioPlayer()
	player.stream =  SoundManager.SFX.get(sfx_name)
	player.pitch_scale = pitch
	player.volume_db = db
	player.play()
	last_played_ms = OS.get_ticks_msec()
