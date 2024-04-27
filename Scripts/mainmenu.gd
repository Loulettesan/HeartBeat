extends Control

@onready var anim = $AnimationPlayer

@onready var slide_music = $SettingsScreen/Options/SoundVbox/VBoxContainer/music
@onready var slide_soundeffect = $SettingsScreen/Options/SoundVbox/VBoxContainer2/soundeffect
@onready var slide_bright = $SettingsScreen/Options/BrightnessVbox/VBoxContainer/Label/bright

@onready var keyb_check = $SettingsScreen/Options/HBoxContainer/VBoxContainer/HBoxContainer2/CheckBox_Keyb
@onready var controller_check = $SettingsScreen/Options/HBoxContainer/VBoxContainer/HBoxContainer/CheckBox_Cont

@onready var confirm_sound = $ButtonConfirm
@onready var decline_sound = $ButtonDecline

var keyb = true
var volume = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$MenuMusic.play()
	$Splash_screen/Creator.hide()
	$Splash_screen/GameEngine.hide()
	$SettingsScreen.hide()
	$Menu.hide()
	anim.play("Splash_Creator")
	anim.queue("Splash_GameEngine")
	anim.queue("Menu")
	await anim.animation_finished
	if Input.get_connected_joypads() == [0]:
		keyb = false
		$Notification.text = " Controller Detected"
		$AnimationPlayer.play("Notification_Show")
	else:
		keyb = true
	$Menu/Buttons/Start.grab_focus()
	$Menu_BG/AnimatedSprite2D.play("menu_anim")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not keyb:
		$SettingsScreen/Options/HBoxContainer/VBoxContainer/InputControls.texture = load("res://GUI/controller.png")
		$SettingsScreen/Exit.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		get_tree().call_group("MainButtons", "mouse_filter", 2)
		slide_music.tick_count = 11
		slide_music.step = 3
		slide_soundeffect.tick_count = 11
		slide_soundeffect.step = 3
	else:
		$SettingsScreen/Options/HBoxContainer/VBoxContainer/InputControls.texture = load("res://GUI/keyb.png") 
		$SettingsScreen/Exit.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().call_group("MainButtons", "mouse_filter", 0)
		slide_music.tick_count = 0
		slide_music.step = 0
		slide_soundeffect.tick_count = 0
		slide_soundeffect.step = 0
		
	if $SettingsScreen/Warning.visible and Input.is_action_just_pressed("decline"):
		slide_soundeffect.button_pressed = false
		controller_check.button_pressed = true
		get_tree().call_group("SettingsButtons", "set_disabled", false)
	if $SettingsScreen.visible and Input.is_action_just_pressed("decline"):
		$SettingsScreen.hide()
		$SettingsScreen/Warning.hide()
		decline_sound.play()
		get_tree().call_group("MainButtons", "set_disabled", false)
		$Menu/Buttons/Settings.grab_focus()

func _on_quit_pressed(): #DONE
	decline_sound.play()
	await decline_sound.finished
	get_tree().quit()

func _on_settings_pressed(): #DONE
	confirm_sound.play()
	get_tree().call_group("MainButtons", "set_disabled", true)
	get_tree().call_group("MainButtons", "focus_mode", "None")
	anim.play("SettingsScreen")
	$SettingsScreen/Options/Language/LangOptions.grab_focus()

func _on_load_pressed():
	confirm_sound.play()
	await confirm_sound.finished
	# get_tree().change_scene("")
	pass # Replace with function body.

func _on_start_pressed():
	confirm_sound.play()
	await confirm_sound.finished
	get_tree().change_scene_to_file("res://Scene/home.tscn")

func _on_exit_pressed(): # Settings
	decline_sound.play()
	$SettingsScreen.hide()
	get_tree().call_group("MainButtons", "set_disabled", false)
	$Menu/Buttons/Settings.grab_focus()

func _on_audio_stream_player_finished(): #DONE
	$AudioStreamPlayer.play()

func _on_check_button_toggled(button_pressed):
	if button_pressed == true:
		confirm_sound.play()
		get_tree().call_group("SettingsButtons", "focus_mode", "None")
		$SettingsScreen/Warning.show()
		$SettingsScreen/Warning/VBoxContainer/Choice/No.grab_focus()
	if button_pressed == false:
		confirm_sound.play()
		keyb = false

func _on_yes_pressed():
	confirm_sound.play()
	get_tree().call_group("SettingsButtons", "set_disabled", false)
	$SettingsScreen/Warning.hide()
	keyb = true

func _on_no_pressed():
	decline_sound.play()
	get_tree().call_group("SettingsButtons", "set_disabled", false)
	slide_soundeffect.button_pressed = false
	controller_check.button_pressed = true
	$SettingsScreen/Warning.hide()
	controller_check.grab_focus()
	keyb = false

func _on_screen_options_item_selected(index):
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_check_box_keyb_toggled(button_pressed):
	if button_pressed == true:
		confirm_sound.play()
		controller_check.button_pressed = false
		get_tree().call_group("SettingsButtons", "focus_mode", "None")
		$SettingsScreen/Warning.show()
		$SettingsScreen/Warning/VBoxContainer/Choice/No.grab_focus()
	if button_pressed == false:
		decline_sound.play()
		controller_check.button_pressed = true
		keyb = false

func _on_check_box_cont_toggled(button_pressed):
	if button_pressed == true:
		confirm_sound.play()
		keyb_check.button_pressed = false
		keyb = false
	if button_pressed == false:
		decline_sound.play()
		keyb_check.button_pressed = true
		keyb = true
		get_tree().call_group("SettingsButtons", "focus_mode", "None")
		$SettingsScreen/Warning.show()
		$SettingsScreen/Warning/VBoxContainer/Choice/No.grab_focus()

func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
	confirm_sound.play()

func _on_soundeffect_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffect"), value)
	confirm_sound.play()

func _on_bright_value_changed(value):
	GlobalWorldEnvironment.environment.set_adjustment_brightness((0.7 + (value/100)))
