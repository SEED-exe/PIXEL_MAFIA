extends CharacterBody2D

const CPU_PARTICLES_2D_BLOOD = preload("res://Scenes/Game/particule/cpu_particles_2d_blood.tscn")
@export_group("PROPERTIES")
#var#
@export var hp_max = 100
var current_hp = 100

var invincible_frame = false

var speed = 140
@export var walk_speed = 100
@export var run_speed = 140
@export var damage_shoot = 20
@export var accel = 5
@export var Couldown_for_stop_searching = 30

@onready var nav : NavigationAgent2D = $NavigationAgent2D
@onready var debug = $label_arm/debug

var player_grp = null
var player = null
var last_enemy_see
var couldown_to_set_gard = false

#range
@export_subgroup("RANDOMIZE THINGS")
@export var range_to_stop_min = 100
@export var range_to_stop_max = 300
var range_to_stop = 100

#FAMILLE NUM#
@export_group("FAMILLE DEBUG")
enum family {
	marino,
	omalley,
	moretti
}

@export var Famille = family.marino

var enemy_grp : Array

#STATE#
enum states {
	gard,
	search,
	chase,
}

var STATE = states.gard

#CONST SPRITE CORP#

@onready var corp_sprite = $CORP_sprite
var sprite_path = ""

#raycast
@onready var ray_cast_2d_vision = $Raycast/RayCast2D_vision
@onready var ray_cast_2d_shoot = $Raycast/RayCast2D_shoot

var see_player = false

#timer
@onready var timer_couldown_not_see_player = $TIMER/Timer_couldown_not_see_player
@onready var muzzleflash = $Weapon/Pistol/Muzzleflash

@onready var timer_search = $TIMER/Timer_search
@onready var timer_shoot = $TIMER/Timer_shoot
@onready var timer_stop_search = $TIMER/Timer_stop_search

var is_searching = false
var timer_couldown_not_see_player_as_start = false
var is_shooting = false
var my_grp = ""
#audio
const AUDIO_STREAM_PLAYER_SHOOT = preload("res://Scenes/Game/sd/audio_stream_player_shoot.tscn")

#search loc#
var rng_y = 0
var rng_x = 0
var last_nav_point = Vector2(0,0)
var origine_pos = Vector2(0,0)



#WEAPON EQUIPED
@onready var pistol = $Weapon/Pistol

func initialize():
	randomize()
	var rng_sprite_gard = randi_range(0,1)
	range_to_stop = randf_range(range_to_stop_min,range_to_stop_max)
	origine_pos = global_position
	current_hp = hp_max
	player_grp = get_tree().get_nodes_in_group("player")
	
	player = player_grp[0]
	
	

	if Famille == family.marino:
		sprite_path = "res://Assets/Sprites/famille/marino/garde_" + str(rng_sprite_gard) + ".png"
		add_to_group("marino")
		
		enemy_grp.append("player")
		enemy_grp.append("moretti")
	if Famille == family.moretti:
		sprite_path = "res://Assets/Sprites/famille/moretti/garde_" + str(rng_sprite_gard) + ".png"
		add_to_group("moretti")
		enemy_grp.append("marino")
		
	corp_sprite.texture = load(sprite_path)
	my_grp = get_groups()
	
func _ready():
	initialize()
	

func damage(_damage,who):
	if current_hp <= 0:
		call_deferred("queue_free")
	else:
		if !invincible_frame:
			invincible_frame = true
			last_enemy_see = who
			look_at(last_enemy_see.global_position)
			var blood_spread = CPU_PARTICLES_2D_BLOOD.instantiate()
			get_parent().add_child(blood_spread)
			blood_spread.global_position = global_position
			current_hp -= _damage
			call_close_ally(who)
			await get_tree().create_timer(1).timeout
			invincible_frame = false

func call_close_ally(who):
	var all_ally = get_tree().get_nodes_in_group(my_grp[1])
	for i in all_ally:
		i.look_at(who.global_position)

func _physics_process(delta):
	var direction = Vector3()
	$label_arm.global_rotation = 0
	
	
	#DO DAMAGE#
	if ray_cast_2d_shoot.get_collider():
		var shoot_collide = ray_cast_2d_shoot.get_collider()
		for i in enemy_grp:
			if shoot_collide.is_in_group(i):
				shoot_collide.damage(damage_shoot,self)
	
	#vision ai
	if ray_cast_2d_vision.get_collider():
		var vision_collider = ray_cast_2d_vision.get_collider()
		var last_target = ray_cast_2d_vision.get_collision_point()
		
		#SI PLAYER DETECTED#
		for i in enemy_grp:
			if vision_collider.is_in_group(i):
				if !invincible_frame:
					last_enemy_see = vision_collider
				
				see_player = true
				STATE = states.chase
				timer_couldown_not_see_player.stop()
				timer_couldown_not_see_player_as_start = false

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
		if is_instance_valid(last_enemy_see):
			nav.target_position = last_enemy_see.global_position
			debug.text = "STATE : CHASE"
			direction = nav.get_next_path_position() - global_position
			direction = direction.normalized()
			
			velocity = velocity.lerp(direction * speed, accel * delta)
			last_nav_point = nav.get_next_path_position()
			look_at(nav.get_next_path_position())
		if see_player && global_position.distance_to(last_enemy_see.global_position) < range_to_stop:
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
		nav.target_position = Vector2(rng_x,rng_y)
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		debug.text = "STATE : SEARCH"
		velocity = velocity.lerp(direction * speed, accel * delta)
		if !invincible_frame:
			look_at(nav.get_next_path_position())
		#if !is_searching:
			#is_searching = true
			#timer_stop_search.start()
		#else:
			#timer_stop_search.stop()
			#is_searching = false
		
		if nav.get_final_position().distance_to(global_position) < 50:
			speed = 0
		else:
			speed = walk_speed
	
	if STATE == states.gard:
		if origine_pos.distance_to(global_position) < 50:
			speed = 0
		else:
			nav.target_position = origine_pos
			direction = nav.get_next_path_position() - global_position
			direction = direction.normalized()
			debug.text = "STATE : GARD"
			velocity = velocity.lerp(direction * speed, accel * delta)
			if !invincible_frame:
				look_at(nav.get_next_path_position())
			speed = walk_speed
		if pistol.visible:
			pistol.visible = false
	
	#distance avant de tier et/ou s'arreter#

	move_and_slide()

	
func _on_timer_couldown_not_see_player_timeout():
	STATE = states.search
	timer_couldown_not_see_player.stop()


func _on_timer_search_timeout():
	if STATE == states.search:
		randomize()
		rng_y = last_nav_point.y + randf_range(0,100)
		rng_x = last_nav_point.x + randf_range(0,100)
		if !STATE == states.gard && !couldown_to_set_gard:
			couldown_to_set_gard = true
			await get_tree().create_timer(Couldown_for_stop_searching).timeout
			STATE = states.gard
			couldown_to_set_gard = false


func _on_visible_on_screen_notifier_2d_screen_exited():
	if STATE == states.search:
		STATE = states.gard


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


func _on_timer_stop_search_timeout():
	if STATE == states.search:
		STATE = states.gard
