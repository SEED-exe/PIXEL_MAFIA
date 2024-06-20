extends AudioStreamPlayer2D


const _9_MM_PISTOL_SHOOT_SHORT_REVERB_7152 = preload("res://Assets/Audio/SFX/9mm/9mm-pistol-shoot-short-reverb-7152.mp3")
const _9_MM_PISTOL_SHOT_6349 = preload("res://Assets/Audio/SFX/9mm/9mm-pistol-shot-6349.mp3")

func _ready():
	play_sound_shoot()
	await get_tree().create_timer(60).timeout
	queue_free()

func play_sound_shoot():
	randomize()
	var rng_sfx = randi_range(0,1)
	var rng_pitch_shoot = randf_range(0.8,1.2)

	if rng_sfx == 0:
		stream = _9_MM_PISTOL_SHOOT_SHORT_REVERB_7152
	else:
		stream = _9_MM_PISTOL_SHOT_6349
	pitch_scale = rng_pitch_shoot
	playing = true
