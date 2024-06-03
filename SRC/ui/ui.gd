extends CanvasLayer

var ui_quest_name : String
var ui_quest_desc : String

@onready var label_quest_name = $Quest/ColorRect/HBoxContainer/Label_quest_name
@onready var animation_player_slide = $Quest/AnimationPlayer_slide
@onready var debug_quest = $CheatBox/VBoxContainer/debug_quest
@onready var label_response = $CheatBox/VBoxContainer/Label_response
@onready var cheat_box = $CheatBox

func _ready():
	debug_quest.text = "index quest : " + str(Globalvar.quest_index)

func update_Quest_line():
	ui_quest_name = Globalvar.quest_name
	ui_quest_desc = Globalvar.quest_desc
	label_quest_name.text = ui_quest_name
	#await get_tree().create_timer(1).timeout
	animation_player_slide.play("slide_quest_notif")
	debug_quest.text = "index quest : " + str(Globalvar.quest_index)
	
func _input(event):
	if Input.is_action_just_pressed("quest"):
		update_Quest_line()
	if Input.is_action_just_pressed("cheat"):
		cheat_box.visible = !cheat_box.visible


func _on_line_edit_commandeline_text_submitted(new_text: String) -> void:
	var regex_setquest = RegEx.new()
	regex_setquest.compile("^/set quest_index ([0-9]+)$") # Expression régulière pour vérifier le format attendu

	var match = regex_setquest.search(new_text)
	
	if match:
		# Le texte correspond au format attendu
		var input_quest_index = match.get_string(1) # Capturer le nombre
		label_response.text = "set quest index to " + input_quest_index
		debug_quest.text = "index quest : " + input_quest_index
		print("Numéro de quête :", input_quest_index)
		Globalvar.quest_index = input_quest_index

	if new_text == "reload scene":
		get_tree().reload_current_scene()

