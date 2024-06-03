extends Node

var Music_Stream : AudioStream

const THE_LAST_ROUND_UP__RESTORED__SPADE_COOLEY_PLAYS_BILLY_HILL_FOR_DANCING = preload("res://Assets/Audio/Spade Cooley plays Billy Hill for dancing/The Last Round-Up (restored) Spade Cooley plays Billy Hill for dancing.wav")

@onready var audio_stream_player_musique = $AudioStreamPlayer_musique


func _ready():
	set_and_play_music()

func set_and_play_music():
	audio_stream_player_musique.stream = THE_LAST_ROUND_UP__RESTORED__SPADE_COOLEY_PLAYS_BILLY_HILL_FOR_DANCING
	audio_stream_player_musique.play(0.0)

func _physics_process(delta):
	if !audio_stream_player_musique.playing:
		set_and_play_music()
