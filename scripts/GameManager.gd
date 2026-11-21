extends Node

class_name GameManager

signal game_state_changed(state)
signal save_completed(slot)
signal load_completed(slot)

var current_save_slot: int = 1
var game_state: Dictionary = {}
var is_paused: bool = false
var player_position: Vector3 = Vector3(0, 0, 0)
var player_health: float = 100.0
var currency: int = 0
var completed_missions: Array = []
var discovered_locations: Array = []
var owned_vehicles: Array = []
var current_vehicle: String = ""

const SAVE_VERSION: int = 1
const MAX_SAVE_SLOTS: int = 5

func _ready():
	Engine.time_scale = 1.0
	_new_game_state()
	print("GameManager ready. Offline-first mode active.")

func _new_game_state():
	game_state = {
		"version": SAVE_VERSION,
		"player_position": player_position,
		"player_health": player_health,
		"currency": currency,
		"completed_missions": completed_missions,
		"discovered_locations": discovered_locations,
		"owned_vehicles": owned_vehicles,
		"current_vehicle": current_vehicle,
		"day_time": 0.0,
		"weather": "clear",
		"current_region": "metro_city",
		"settings": {
			"graphics_quality": 1,
			"sound_volume": 0.7,
			"music_volume": 0.6,
			"camera_sensitivity": 1.0,
			"control_sensitivity": 1.0,
			"language": "en"
		}
	}

func new_game():
	_new_game_state()
	current_save_slot = 1
	player_position = Vector3(0, 5, 0)
	currency = 500
	game_state["currency"] = currency
	save_game(current_save_slot)
	game_state_changed.emit(game_state)
	print("New game started. Slot: ", current_save_slot)

func save_game(slot: int) -> bool:
	var file = FileAccess.open("user://save_slot_" + str(slot) + ".json", FileAccess.WRITE)
	if file == null:
		push_error("SaveSystem: cannot open save file for slot " + str(slot))
		return false
	game_state["player_position"] = player_position
	game_state["currency"] = currency
	game_state["completed_missions"] = completed_missions
	game_state["discovered_locations"] = discovered_locations
	game_state["owned_vehicles"] = owned_vehicles
	game_state["current_vehicle"] = current_vehicle
	var json = JSON.stringify(game_state)
	file.store_string(json)
	file.close()
	save_completed.emit(slot)
	print("SaveSystem: saved to slot ", slot)
	return true

func load_game(slot: int) -> bool:
	var file = FileAccess.open("user://save_slot_" + str(slot) + ".json", FileAccess.READ)
	if file == null:
		push_error("SaveSystem: no save file for slot " + str(slot))
		return false
	var content = file.get_as_text()
	file.close()
	var json = JSON.new()
	var result = json.parse(content)
	if result.error != OK:
		push_error("SaveSystem: invalid JSON in slot " + str(slot))
		return false
	game_state = result.result
	player_position = game_state.get("player_position", Vector3(0, 5, 0))
	currency = game_state.get("currency", 0)
	completed_missions = game_state.get("completed_missions", [])
	discovered_locations = game_state.get("discovered_locations", [])
	owned_vehicles = game_state.get("owned_vehicles", [])
	current_vehicle = game_state.get("current_vehicle", "")
	current_save_slot = slot
	load_completed.emit(slot)
	game_state_changed.emit(game_state)
	print("SaveSystem: loaded slot ", slot)
	return true

func autosave():
	save_game(current_save_slot)

func get_state() -> Dictionary:
	return game_state.duplicate()

func set_player_position(pos: Vector3):
	player_position = pos
	game_state["player_position"] = pos

func add_currency(amount: int):
	currency += amount
	game_state["currency"] = currency

func spend_currency(amount: int) -> bool:
	if currency >= amount:
		currency -= amount
		game_state["currency"] = currency
		return true
	return false

func queue_save():
	autosave()