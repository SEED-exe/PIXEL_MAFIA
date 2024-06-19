extends CanvasLayer

var ui_quest_name : String
var ui_quest_desc : String

var ninemm_curent_ammo_gv = 0
var ninemm_magazin_gv = 0

var player = null
@onready var label_quest_name = $Quest/ColorRect/HBoxContainer/Label_quest_name
@onready var animation_player_slide = $Quest/AnimationPlayer_slide
@onready var debug_quest = $CheatBox/VBoxContainer/debug_quest
@onready var label_response = $CheatBox/VBoxContainer/Label_response
@onready var cheat_box = $CheatBox
@onready var interactive_wheel = $Interactive_wheel

@onready var label_ninemm_ammo = $Interactive_wheel/TextureButton_pistol/Label_ninemm_ammo
@onready var label_ninemm_ammo_2 = $info/Label_ninemm_ammo2


func _ready():
	player = get_parent()
	debug_quest.text = "index quest : " + str(Globalvar.quest_index)
	update_player_var()
	
func update_Quest_line():
	ui_quest_name = Globalvar.quest_name
	ui_quest_desc = Globalvar.quest_desc
	label_quest_name.text = ui_quest_name
	#await get_tree().create_timer(1).timeout
	animation_player_slide.play("slide_quest_notif")
	debug_quest.text = "index quest : " + str(Globalvar.quest_index)
	
func _input(_event):
	if Input.is_action_just_pressed("quest"):
		update_Quest_line()
	if Input.is_action_just_pressed("cheat"):
		cheat_box.visible = !cheat_box.visible
	if Input.is_action_pressed("interactiv_wheel"):
		if !interactive_wheel.visible:
			interactive_wheel.visible = true
			get_tree().paused = true
			update_player_var()
			
			#update texte
			label_ninemm_ammo.text = (str(ninemm_curent_ammo_gv)+ " / "+ str(ninemm_magazin_gv))
			
	else:
		interactive_wheel.visible = false
		Engine.time_scale = 1
		get_tree().paused = false

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
		var to_int = input_quest_index.to_int()
		Globalvar.change_quest(to_int)

	if new_text == "reload scene":
		get_tree().reload_current_scene()
	else:
		print("mauvaise commande !")

func update_player_var():
	ninemm_curent_ammo_gv = player.ninemmm_current_ammo
	ninemm_magazin_gv = player.ninemm_magazin
	
	label_ninemm_ammo_2.text = (str(ninemm_curent_ammo_gv)+ " / "+ str(ninemm_magazin_gv))
	
