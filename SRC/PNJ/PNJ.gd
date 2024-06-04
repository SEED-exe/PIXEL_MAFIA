extends CharacterBody2D

enum pnj {
	Vinnie,
}

@export var index_pnj = pnj.Vinnie
@export var player_path : NodePath
var player = get_node

@onready var label_e_to_talk = $Label_e_to_talk


func _ready():
	player = get_node(player_path)
	
	Dialogic.signal_event.connect(DialogicSignal)

func _physics_process(delta):
	if player == null : return
	var distance_to_player = global_position.distance_to(player.global_position)
	if distance_to_player < 50:
		if Input.is_action_just_pressed("interact"):
			player.can_move = false
			if Globalvar.quest_index == 1:
				Dialogic.start("Scene2")
			else:
				Dialogic.start("Vinnierng")
		if !label_e_to_talk.visible:
			label_e_to_talk.visible = true
			
	else:
		if label_e_to_talk.visible:
			label_e_to_talk.visible = false
				

func DialogicSignal(arg : String):
	if arg == "exit_dialogue":
		player.can_move = true
	if arg == "exit_scene_2":
		var next_quest = Globalvar.quest_index + 1
		Globalvar.change_quest(next_quest)
		player.can_move = true
		player.update_Quest_line(next_quest)
