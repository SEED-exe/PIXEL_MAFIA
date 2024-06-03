extends Node2D

@onready var animation_player_aa = $"Ascenseur a/AnimationPlayer_aa"

func _ready():
	animation_player_aa.play("open dort")
