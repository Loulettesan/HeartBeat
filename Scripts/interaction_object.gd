extends Node2D

@export var description = []
@export var diag: String = ""

@onready var dialogue_node = preload("res://Scene/player.tscn").instantiate()

signal InteractButton_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	if diag:
		var dialogue = DialoguesHouse.get("diag") 
	if description != []:
		if typeof(description[0]) == 28:
			print("Array")
			pass
		if typeof(description[0]) == 4:
			print("String")
			pass
		else:
			print(typeof(description[0]))
			print("Dont Work")
			pass

func _input(event):
	if Input.is_action_pressed("accept"):
		InteractButton_pressed.emit()

func _on_area_2d_area_entered(area):
	$AnimationPlayer.play("can_interact")
	print("Is in")
	while $Area2D.has_overlapping_areas():
		await get_tree().get_nodes_in_group("Dialogue")[0].dialogue_show == false
		await InteractButton_pressed
		$Timer.start(0.2)
		await $Timer.timeout
		if not $Area2D.has_overlapping_areas():
			break
		get_tree().call_group("Dialogue", "begin_dialogue", description)
		await InteractButton_pressed
		$Timer.start(0.5)
		await $Timer.timeout

func _on_area_2d_area_exited(area):
	$AnimationPlayer.play("exit_area")
