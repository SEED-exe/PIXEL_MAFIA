extends Area2D

var current_quest_index : int
var next_quest_index : int


@export var player_path : NodePath
@export var next_quest = true
@export var lunch_dialog = false
@export var dialogue_name = ""
@export var actual_quest_index : int
var player = null
@onready var animation_player = $AnimationPlayer

func _ready():
	if actual_quest_index != Globalvar.quest_index:
		queue_free()
	animation_player.play("idle")
	player = get_node(player_path)
	Dialogic.signal_event.connect(DialogicSignal)

func _physics_process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("player"):
		
		if next_quest:
			current_quest_index = Globalvar.quest_index
			next_quest_index = current_quest_index +1
			
			
		if lunch_dialog:
			Dialogic.start(dialogue_name)
			player.can_move = false

func DialogicSignal(arg : String):
	if next_quest:
		player.update_Quest_line(next_quest_index)
	if arg == "exit_scene_2":
		player.can_move = true
		queue_free()
	
