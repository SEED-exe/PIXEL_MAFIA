extends CharacterBody2D

var speed = 150

var can_move = true

var zoom = Vector2(0.1,0.1)

#ONREADY VAR#

@onready var sprite_grp = $Sprite_grp
@onready var ui = $UI
@onready var camera_2d = $Camera2D
@onready var arrow_player = $ArrowPlayer

#ANIMATION#
@onready var animation_player_movment = $Animation_grp/AnimationPlayer_movment
@onready var animation_player_arrow = $Animation_grp/AnimationPlayer_arrow


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
		
func update_Quest_line(index_quest):
	Globalvar.change_quest(index_quest)
	ui.update_Quest_line()
