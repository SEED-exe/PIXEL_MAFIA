extends Node2D

@onready var animation_player = $CanvasLayer/AnimationPlayer
@onready var player = $player

func _ready():
	
	animation_player.play("fade")
	player.can_move = false
	
	Dialogic.start("Scene01")
	Dialogic.signal_event.connect(DialogicSignal)
	
	
	
func DialogicSignal(arg : String):
	if arg == "exit_scene_1":
		player.can_move = true
		player.update_Quest_line(1)
