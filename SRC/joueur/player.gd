extends CharacterBody2D

var speed = 150

var can_move = true

var zoom = Vector2(0.1,0.1)

#ONREADY VAR#
@onready var collision_polygon_2d_corp = $CollisionPolygon2D_corp

@onready var sprite_grp = $Sprite_grp
@onready var ui = $UI
@onready var camera_2d = $Camera2D
@onready var arrow_player = $ArrowPlayer

@onready var muzzleflash = $Sprite_grp/weapon_arm/Muzzleflash

#ANIMATION#
@onready var animation_player_movment = $Animation_grp/AnimationPlayer_movment
@onready var animation_player_arrow = $Animation_grp/AnimationPlayer_arrow

#ATK
var ninemmm_current_ammo = 33
var ninemm_max_ammo = 33

var ninemm_magazin = 5

var couldown_pistol = false

@onready var ray_cast_2d_shoot = $Sprite_grp/RayCast2D_shoot

#sfx
const AUDIO_STREAM_PLAYER_SHOOT = preload("res://Scenes/Game/sd/audio_stream_player_shoot.tscn")

const _9_MM_PISTOL_SHOOT_SHORT_REVERB_7152 = preload("res://Assets/Audio/SFX/9mm/9mm-pistol-shoot-short-reverb-7152.mp3")
const _9_MM_PISTOL_SHOT_6349 = preload("res://Assets/Audio/SFX/9mm/9mm-pistol-shot-6349.mp3")
const CPU_PARTICLES_2D_BLOOD = preload("res://Scenes/Game/particule/cpu_particles_2d_blood.tscn")

func _ready():
	animation_player_arrow.play("idle_arrow")
	
func _physics_process(delta):
	var marqueur = get_tree().get_nodes_in_group("marqueur")
	if marqueur.size() > 0:
		
		if !arrow_player.visible:
			animation_player_arrow.play_backwards("fade")
			arrow_player.visible = true
		if is_instance_valid(marqueur[0]):
			arrow_player.look_at(marqueur[0].global_position)
	else:
		if arrow_player.visible:
			animation_player_arrow.play("fade")
			
	
	if can_move:
		sprite_grp.look_at(get_global_mouse_position())
		collision_polygon_2d_corp.look_at(get_global_mouse_position())
		
		var direction = Input.get_vector("left","right","up","down")
		if direction == Vector2(0,0):
			animation_player_movment.play("idle")
		else:
			animation_player_movment.play("walk")
		velocity = direction * speed
		
		
		move_and_slide()

func _input(event):
	if Input.is_action_just_released("wheel up"):
		if camera_2d.zoom < Vector2(2,2):
			camera_2d.zoom += zoom
		
	if Input.is_action_just_released("wheel down"):
		if camera_2d.zoom > Vector2(0.8,0.8):
			camera_2d.zoom -= zoom
	if Input.is_action_just_released("wheel_reset"):
		camera_2d.zoom = Vector2(1.8,1.8)
	
	if Input.is_action_pressed("reload"):
		ui.update_player_var()
		if ninemmm_current_ammo < 33:
			if ninemm_magazin >= 1:
				ninemm_magazin -= 1
				ninemmm_current_ammo = 33
				
	if Input.is_action_pressed("attack") && ninemmm_current_ammo >= 1:
		if !couldown_pistol:
			muzzleflash.visible = true
			couldown_pistol = true
			ninemmm_current_ammo -=1
			play_sound_shoot()
			ui.update_player_var()
			if ray_cast_2d_shoot.get_collider():
				var collide = ray_cast_2d_shoot.get_collider()
				if collide.is_in_group("attackable"):
					collide.damage(10)
			await get_tree().create_timer(0.1).timeout
			muzzleflash.visible = false
			await get_tree().create_timer(0.5).timeout
			couldown_pistol = false
		
	if Input.is_action_pressed("run"):
		speed = 210
	else:
		speed = 140
		
		
func update_Quest_line(index_quest):
	Globalvar.change_quest(index_quest)
	ui.update_Quest_line()


func damage(_damage):
	print(_damage)
	var blood_spread = CPU_PARTICLES_2D_BLOOD.instantiate()
	get_parent().add_child(blood_spread)
	blood_spread.global_position = global_position

#SOUND EFFECT & MUSIQUE#

func play_sound_shoot():
	
	var audio_stream_player_shoot = AUDIO_STREAM_PLAYER_SHOOT.instantiate()
	
	self.add_child(audio_stream_player_shoot)




















