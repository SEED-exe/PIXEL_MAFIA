extends Node

#QUEST VAR
var quest_name : String
var quest_index : int
var quest_desc : String

func change_quest(index_quest):
	quest_index = index_quest
	update_quest(quest_index)
	

func update_quest(quest_index):
	if quest_index == 0:
		quest_name = ""
		quest_desc = ""
		
	if quest_index == 1:
		quest_name = "Descendez rejoindre votre ami."
		quest_desc = "Trouver vous des habits et changer vous devant le miroir."
		
	if quest_index == 2:
		quest_name = "test"
		quest_desc = "test"
		
