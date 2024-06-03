extends Area2D

@export var next_scene = ""

@onready var animation_player = $AnimationPlayer

@export var player_path : NodePath
var player = null

func _ready():
	player = get_node(player_path)

func _on_body_entered(body):
	if body.is_in_group("player"):
		change_scene()
		player.can_move = false

func change_scene():
	animation_player.play("fade")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file(next_scene)
