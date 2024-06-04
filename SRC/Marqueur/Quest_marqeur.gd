extends Area2D

@onready var animation_player = $AnimationPlayer

@export var current_quest_to_show : int

@onready var sprite_2d = $Sprite2D

func _ready():
	animation_player.play("idle")
	if !Globalvar.quest_index == current_quest_to_show:
		_show(false)

func _physics_process(delta):
	if Globalvar.quest_index == current_quest_to_show:
		_show(true)
	else:
		_show(false)


func _on_body_entered(body):
	if body.is_in_group("player"):
		if !Globalvar.quest_index == current_quest_to_show:
			_show(false)

func _show(show):
	if !show && sprite_2d.visible:
		remove_from_group("marqueur")
		sprite_2d.visible = false
	if show && !sprite_2d.visible:
		add_to_group("marqueur")
		sprite_2d.visible = true
