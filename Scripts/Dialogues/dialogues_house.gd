extends Node
# Structure :
# List of Dict (Dict are one dialogue and List is all dialogues of the interaction)

# {chara="", text="", choice=["",""], result=[]}
# chara -> character who's speaking
# text -> text
# choice -> list of str 
# result -> list of result: (String) or (StringName() to interact with a node, usally teleporting) or (Scene Path) 

### SIMPLE INTERACTIONS ###
var mirror = [{chara="", text="C'est toi."}]
var mirror_easter = [{chara="", text="Il n'y a rien derrière toi..."}]
var bed = [{chara="", text="Tu as l'impression que ton lit est en train de t'attirer pour que tu t'y allonges."},
		{chara="", text="Tu resistes à la tentation."}]
var fridge = [{chara="", text="Il est vide... Elle est déjà partie faire des courses."}, 
		{chara="", text="Elle ne devrait pas tarder."}]
var shower = [{chara="", text="Prendre une douche ?", choice=["Oui","Plus tard"], result=[StringName("Douche"),""]}]
var library = [{chara="", text="Elle est remplie de livre sur les sciences, tu n'en as lu aucun."}]
var momdoor = [{chara="", text="C'est sa chambre."}]

### TELEPORT ###
var stairsdoor = [{chara="", text="Aller à l'étage ?", choice=["Oui", "Non"], result=[StringName("Floor"), ""]}]
var exithouse = [{chara="", text="Sortir de la maison ?", choice=["Oui", "Non"], result=["res://Scene/outside.tscn", ""]}]
var exitfloor = [{chara="", text="Retourner en bas ?", choice=["Oui","Non"], result=[StringName("Ground"),""]}]

### CUTSCENE ###
