extends Node

class_name MainGame

@export var player_scene: PackedScene
@export var vehicle_scene: PackedScene

var player = null
var camera = null
var ground = null
var vehicle = null
var move_input: Vector2 = Vector2.ZERO

func _ready() -> void:
	ground = Node3D.new()
	ground.name = "Ground"
	add_child(ground)
	var mi = MeshInstance3D.new()
	mi.mesh = PlaneMesh.new()
	mi.mesh.size = Vector2(500, 500)
	mi.mesh.material = _make_material(Color(0.2, 0.55, 0.25, 1.0))
	ground.add_child(mi)
	var sb = StaticBody3D.new()
	var col = CollisionShape3D.new()
	col.shape = BoxShape3D.new()
	col.shape.size = Vector3(500, 1, 500)
	sb.add_child(col)
	ground.add_child(sb)
	if player_scene:
		player = player_scene.instantiate()
		player.position = Vector3(0, 1, 0)
		add_child(player)
	if vehicle_scene:
		vehicle = vehicle_scene.instantiate()
		vehicle.position = Vector3(5, 1, 0)
		add_child(vehicle)
	get_node("/root/World").building_count = 14
	get_node("/root/World")._generate_city_block()
	get_node("/root/World").spawn_traffic(6)
	print("Main: world generated")
	camera = get_node_or_null("GameRoot/Camera3D")

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var dx = 0.0
		var dz = 0.0
		if event.keycode == KEY_W or event.keycode == KEY_UP: dz = -1.0
		if event.keycode == KEY_S or event.keycode == KEY_DOWN: dz = 1.0
		if event.keycode == KEY_A or event.keycode == KEY_LEFT: dx = -1.0
		if event.keycode == KEY_D or event.keycode == KEY_RIGHT: dx = 1.0
		if dx != 0.0 or dz != 0.0:
			move_input = Vector2(dx, dz).normalized()
			if player:
				if player.in_vehicle and vehicle:
					var steer = dx
					var throttle = 0.0
					var brake = 0.0
					if dz < 0: throttle = 1.0
					if dz > 0: brake = 1.0
					vehicle.set_input(steer, throttle, brake)
				else:
					player.set_input(move_input)
		else:
			move_input = Vector2.ZERO
			if player:
				if player.in_vehicle and vehicle:
					vehicle.set_input(0.0, 0.0, 0.0)
				else:
					player.set_input(move_input)
		if event.keycode == KEY_SHIFT:
			if player and not player.in_vehicle:
				player.set_sprint(event.pressed)
		if event.pressed and event.keycode == KEY_E:
			if player:
				player._check_interaction()

func _process(delta: float) -> void:
	if camera and player:
		var target_pos = player.global_position + Vector3(0, 6, -10)
		if player.in_vehicle and vehicle:
			target_pos = vehicle.global_position + Vector3(0, 5, -8)
		camera.global_position = camera.global_position.lerp(target_pos, delta * 5.0)
		var look_target = player.global_position + Vector3(0, 1, 0)
		if player.in_vehicle and vehicle:
			look_target = vehicle.global_position
			var ui = get_node_or_null("/root/UI")
			if ui:
				ui.set_speed(vehicle.get_speed())
		camera.look_at(look_target)

func _make_material(color: Color) -> StandardMaterial3D:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	return mat