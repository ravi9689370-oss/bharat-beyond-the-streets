extends Node

class_name UI

var menu_layer: CanvasLayer = null
var hud_layer: CanvasLayer = null

func _ready() -> void:
	_create_main_menu()
	_create_hud()
	show_main_menu(true)

func _create_main_menu() -> void:
	menu_layer = CanvasLayer.new()
	menu_layer.name = "MainMenu"
	var center = CenterContainer.new()
	var vbox = VBoxContainer.new()
	var title = Label.new()
	title.text = "BHARAT: BEYOND THE STREETS"
	vbox.add_child(title)
	var btn_new = Button.new()
	btn_new.text = "New Game"
	btn_new.pressed.connect(_on_new_game)
	vbox.add_child(btn_new)
	var btn_cont = Button.new()
	btn_cont.text = "Continue"
	btn_cont.pressed.connect(_on_continue)
	vbox.add_child(btn_cont)
	var btn_exit = Button.new()
	btn_exit.text = "Exit"
	btn_exit.pressed.connect(get_tree().quit)
	vbox.add_child(btn_exit)
	center.add_child(vbox)
	menu_layer.add_child(center)
	add_child(menu_layer)
	menu_layer.visible = false

func _create_hud() -> void:
	hud_layer = CanvasLayer.new()
	hud_layer.name = "HUD"
	var label = Label.new()
	label.name = "SpeedLabel"
	label.position = Vector2(20, 20)
	label.text = "Speed: 0 km/h"
	hud_layer.add_child(label)
	var interact = Label.new()
	interact.name = "InteractLabel"
	interact.position = Vector2(20, 50)
	interact.text = "E - Interact"
	interact.visible = false
	hud_layer.add_child(interact)
	add_child(hud_layer)
	hud_layer.visible = true

func show_main_menu(show: bool) -> void:
	if menu_layer:
		menu_layer.visible = show
	if hud_layer:
		hud_layer.visible = not show

func _on_new_game() -> void:
	var gm = get_node("/root/GameManager")
	gm.new_game()
	show_main_menu(false)
	print("UI: new game")

func _on_continue() -> void:
	var gm = get_node("/root/GameManager")
	if gm.load_game(1):
		show_main_menu(false)
		print("UI: continued")
	else:
		gm.new_game()
		show_main_menu(false)
		print("UI: no save, new game")

func set_speed(speed: float) -> void:
	if hud_layer:
		var lbl = hud_layer.get_node_or_null("SpeedLabel")
		if lbl:
			lbl.text = "Speed: " + str(round(speed * 3.6)) + " km/h"

func set_interact(show: bool) -> void:
	if hud_layer:
		var lbl = hud_layer.get_node_or_null("InteractLabel")
		if lbl:
			lbl.visible = show