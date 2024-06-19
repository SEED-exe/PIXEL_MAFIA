extends CharacterBody2D

const CPU_PARTICLES_2D_BLOOD = preload("res://Scenes/Game/particule/cpu_particles_2d_blood.tscn")

@export var hp_max = 100
var current_hp = 100

var invincible_frame = false

@export var speed = 140
@export var accel = 5

@onready var nav : NavigationAgent2D = $NavigationAgent2D

var player_grp = null
var player = null

#STATE#

var search = false
var gard = false
var chase = false

func _init():
	current_hp = hp_max


func _ready():
	player_grp = get_tree().get_nodes_in_group("player")
	player = player_grp[0]

func damage(_damage):
	if current_hp <= 0:
		queue_free()
	else:
		if !invincible_frame:
			var blood_spread = CPU_PARTICLES_2D_BLOOD.instantiate()
			get_parent().add_child(blood_spread)
			blood_spread.global_position = global_position
			
			current_hp -= _damage

			invincible_frame = true
			await get_tree().create_timer(1).timeout
			invincible_frame = false


func _physics_process(delta):
	var direction = Vector3()
	
	nav.target_position = player.global_position
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * speed, accel * delta)
	
	move_and_slide()
	
	
	
	
	
	
	
	
	
