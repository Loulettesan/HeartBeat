extends CharacterBody2D

@export var move_speed : float = 150 # Pour le mettre modifiable via l'inspecteur du Node CHARACTERBODY2D
@export var starting_direction : Vector2 = Vector2(0,1)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func _ready():
	update_animation_parameters(starting_direction)

func _physics_process(delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	update_animation_parameters(input_direction)
	
	# MAJ la Velocité
	velocity = input_direction * move_speed
	
	move_and_slide()
	
	pick_new_state()

func update_animation_parameters(move_input : Vector2):
	# Ne change pas les parametres d'animation si il n'y a pas de mouvement
	if (move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)

# Choisir entre l'animation WALK ou IDLE suivant le mouvement du joueur
func pick_new_state():
	if (velocity != Vector2.ZERO):
		if state_machine.get_current_node() != "Walk":
			state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")

func change_pos(pos: Vector2):
	self.position = pos
	move_and_slide()