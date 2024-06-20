extends CharacterBody2D

const CPU_PARTICLES_2D_BLOOD = preload("res://Scenes/Game/particule/cpu_particles_2d_blood.tscn")

@export var hp_max = 100
var current_hp = 100

var invincible_frame = false

@export var speed = 140
const walk_speed = 100
const run_speed = 140

@export var accel = 5

@onready var nav : NavigationAgent2D = $NavigationAgent2D
@onready var debug = $debug

var player_grp = null
var player = null

#STATE#

enum states {
	gard,
	search,
	chase,
}

var STATE = states.gard

#raycast
@onready var ray_cast_2d_vision = $Raycast/RayCast2D_vision
@onready var ray_cast_2d_shoot = $Raycast/RayCast2D_shoot

var see_player = false

#timer
@onready var timer_couldown_not_see_player = $TIMER/Timer_couldown_not_see_player
@onready var muzzleflash = $Weapon/Pistol/Muzzleflash

@onready var timer_search = $TIMER/Timer_search
@onready var timer_shoot = $TIMER/Timer_shoot

var timer_couldown_not_see_player_as_start = false
var is_shooting = false

#audio
const AUDIO_STREAM_PLAYER_SHOOT = preload("res://Scenes/Game/sd/audio_stream_player_shoot.tscn")

#search loc#
var rng_y = 0
var rng_x = 0
var last_nav_point = Vector2(0,0)
var origine_pos = Vector2(0,0)

#range
var range_to_stop = 250

#WEAPON EQUIPED
@onready var pistol = $Weapon/Pistol

func _init():
	current_hp = hp_max


func _ready():
	origine_pos = global_position
	player_grp = get_tree().get_nodes_in_group("player")
	player = player_grp[0]

func damage(_damage):
	if current_hp <= 0:
		queue_free()
	else:
		if !invincible_frame:
			look_at(player.global_position)
			var blood_spread = CPU_PARTICLES_2D_BLOOD.instantiate()
			get_parent().add_child(blood_spread)
			blood_spread.global_position = global_position
			
			current_hp -= _damage

			invincible_frame = true
			await get_tree().create_timer(1).timeout
			invincible_frame = false


func _physics_process(delta):
	var direction = Vector3()
	
	debug.text = str(timer_couldown_not_see_player.time_left,"
	",str(STATE))
	
	#DO DAMAGE#
	if ray_cast_2d_shoot.get_collider():
		var shoot_collide = ray_cast_2d_shoot.get_collider()
		if shoot_collide.is_in_group("player"):
			shoot_collide.damage(10)
	
	#vision ai
	if ray_cast_2d_vision.get_collider():
		var vision_collider = ray_cast_2d_vision.get_collider()
		var last_target = ray_cast_2d_vision.get_collision_point()
		
		#SI PLAYER DETECTED#
		if vision_collider.is_in_group("player"):
			see_player = true
			STATE = states.chase
			timer_couldown_not_see_player.stop()
			timer_couldown_not_see_player_as_start = false
		else:
			see_player = false
	else:
		see_player = false
		if STATE == states.chase && !see_player:
			if !timer_couldown_not_see_player_as_start:
				timer_couldown_not_see_player_as_start = true
				timer_couldown_not_see_player.start()

	#chase player#
	if STATE == states.chase:
		if !pistol.visible:
			pistol.visible = true
		
		range_to_stop = 250
		nav.target_position = player.global_position
		
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		
		velocity = velocity.lerp(direction * speed, accel * delta)
		last_nav_point = nav.get_next_path_position()
		look_at(nav.get_next_path_position())
		if see_player && global_position.distance_to(player.global_position) < 700:
			speed = 0
			if !is_shooting:
				is_shooting = true
				timer_shoot.start()
		else:
			speed = run_speed
			is_shooting = false
			timer_shoot.stop()
			ray_cast_2d_shoot.target_position.x = 0
		

	if STATE == states.search:
		range_to_stop = 50
		nav.target_position = Vector2(rng_x,rng_y)
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		
		velocity = velocity.lerp(direction * speed, accel * delta)
		look_at(nav.get_next_path_position())
	
	if STATE == states.gard:
		if pistol.visible:
			pistol.visible = false
		range_to_stop = 0
	
	#distance avant de tier et/ou s'arreter#
	
	
	move_and_slide()

	
func _on_timer_couldown_not_see_player_timeout():
	STATE = states.search
	timer_couldown_not_see_player.stop()


func _on_timer_search_timeout():
	if STATE == states.search:
		randomize()
		rng_y = last_nav_point.y + randf_range(0,200)
		rng_x = last_nav_point.x + randf_range(0,200)


func _on_visible_on_screen_notifier_2d_screen_exited():
	if STATE == states.search:
		STATE = states.gard
		global_position = origine_pos


func _on_timer_shoot_timeout():
	muzzleflash.visible = true
	ray_cast_2d_shoot.target_position.x = 1100
	ray_cast_2d_shoot.target_position.y = randf_range(-300,300)
	timer_shoot.wait_time = randi_range(0.5,3)
	play_sound_shoot()
	await get_tree().create_timer(0.1).timeout
	muzzleflash.visible = false
	ray_cast_2d_shoot.target_position.x = 0
	ray_cast_2d_shoot.target_position.y = 0

func play_sound_shoot():
	
	var audio_stream_player_shoot = AUDIO_STREAM_PLAYER_SHOOT.instantiate()
	
	self.add_child(audio_stream_player_shoot)
