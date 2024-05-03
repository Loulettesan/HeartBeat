extends NinePatchRect

@export var description = []
var choice_teleport : StringName = ""
var choice_changescene : String = ""

signal NextButton_pressed
var dialogue_show = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_action_pressed("accept"):
		NextButton_pressed.emit()

func begin_dialogue(node_description): # 0 : Name , 1 : Text , 2 : If Choice, 3 : Impact
	get_tree().paused = true
	print(node_description)
	if typeof(node_description) == 28: # If only one line (one array)
		$Name.text = node_description[0]
		$Speech.text = node_description[1]
		dialogue_show = true
		$AnimationPlayer.play("appear")
		if node_description.size() >= 3:
			if typeof(node_description[2]) == 28: # == Choice (only 2 options for now)
				$ChoiceContainer.show()
				$ChoiceContainer/Choice1.text = node_description[2][0]
				$ChoiceContainer/Choice2.text = node_description[2][1]
				$ChoiceContainer/Choice1.grab_focus()
				if typeof(node_description[3]) == 21: # == Change Pos (ex : teleport)
					choice_teleport = node_description[3]
				elif node_description[3].begins_with("res://") : # == Change Scene 
					choice_changescene = node_description[3]
		
		await NextButton_pressed
		$AnimationPlayer.play("disappear")
		$Name.text = ""
		$Speech.text = ""
		dialogue_show = false
	elif typeof(node_description[0]) == 27: # Long dialogue (multiple arrays in the dictionnary)
		pass
	elif typeof(node_description[0][0]) == 27: # Cinematic
		pass
	else:
		print("Type don't match", typeof(node_description))
	get_tree().paused = false
	

func _on_choice_1_pressed(): # Bouton Positif (Oui, D'accord, Prendre ...)
	$TextureRect.visible = true
	$AnimationPlayer.play("fade")
	$Timer.start(1)
	await $Timer.timeout
	$ChoiceContainer.hide()
	$AnimationPlayer.play("disappear")
	$Timer.start(1)
	await $Timer.timeout
	if choice_changescene != "":
		get_tree().change_scene_to_file(choice_changescene)
	elif choice_teleport != "":
		get_tree().call_group("Rpg_Player", "change_pos", get_node("/root/Node2D/Pos_Points/"+choice_teleport).get_position())
		$Timer.start(3)
		await $Timer.timeout
		$AnimationPlayer.queue("unfade")
		$TextureRect.visible = false


func _on_choice_2_pressed(): # Bouton Négatif (Non, Refuser, Laisser ...)
	$ChoiceContainer.hide()
