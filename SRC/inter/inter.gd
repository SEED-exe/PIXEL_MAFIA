extends StaticBody2D


@export var light_path : NodePath
var light = null

@export var player_path : NodePath
var player = null

@onready var label_press_e = $Label_press_e
@onready var sprite_2d = $Sprite2D



func _ready():
	light = get_node(light_path)
	player = get_node(player_path)

func _physics_process(delta):
	var dist = player.global_position.distance_to(global_position)
	if dist < 40:
		label_press_e.visible = true
	else:
		if label_press_e.visible:
			label_press_e.visible = false

func _input(event):
	if Input.is_action_just_pressed("interact"):
		if label_press_e.visible:
			light.enabled = !light.enabled
			if light.enabled:
				sprite_2d.frame = 1
			if !light.enabled:
				sprite_2d.frame = 0
