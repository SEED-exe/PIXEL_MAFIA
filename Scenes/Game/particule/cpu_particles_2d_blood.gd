extends CPUParticles2D

const _1_0 = preload("res://Assets/NEw pack blood/1/1_0.png")
const _1_1 = preload("res://Assets/NEw pack blood/1/1_1.png")

var blood_path = "res://Assets/NEw pack blood/1/1_"

func _ready():
	var rng_blood = randi_range(0,13)
	var new_path = blood_path + str(1) + ".png"
	var blood_texture = load(new_path)
	texture = blood_texture
	emitting = true


func _on_finished():
	queue_free()
