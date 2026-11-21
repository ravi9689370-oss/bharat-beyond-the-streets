extends Node

class_name World

@export var region_name: String = "metro_city"
@export var building_count: int = 12

var buildings: Array = []
var traffic_vehicles: Array = []

const REGIONS: Array = [
	"metro_city", "old_city", "rural_india", "desert_region",
	"mountain_region", "coastal_region", "forest_region", "festival_city"
]

func _ready() -> void:
	print("World ready: region=", region_name)

func _generate_city_block() -> void:
	var spacing = 14.0
	var start = -42.0
	var placed = 0
	var rng = RandomNumberGenerator.new()
	rng.seed = 42
	for i in range(6):
		for j in range(6):
			if rng.randf() > 0.55 and placed < building_count:
				var x = start + i * spacing + rng.randf_range(-2.0, 2.0)
				var z = start + j * spacing + rng.randf_range(-2.0, 2.0)
				var h = rng.randf_range(4.0, 22.0)
				var b = _make_building(x, h, z)
				if b:
					buildings.append(b)
					add_child(b)
					placed += 1
	print("World: placed ", placed, " buildings in ", region_name)

func _make_building(x: float, h: float, z: float) -> StaticBody3D:
	var sb = StaticBody3D.new()
	sb.name = "Building"
	var mi = MeshInstance3D.new()
	mi.mesh = BoxMesh.new()
	mi.mesh.size = Vector3(8.0, h, 8.0)
	mi.position = Vector3(0, h/2, 0)
	mi.material_override = _mat(Color(0.85, 0.8, 0.7, 1.0))
	sb.add_child(mi)
	var col = CollisionShape3D.new()
	col.shape = BoxShape3D.new()
	col.shape.size = Vector3(8.0, h, 8.0)
	sb.add_child(col)
	sb.position = Vector3(x, 0, z)
	return sb

func _mat(c: Color) -> StandardMaterial3D:
	var m = StandardMaterial3D.new()
	m.albedo_color = c
	return m

func spawn_traffic(count: int) -> void:
	var rng = RandomNumberGenerator.new()
	rng.seed = 123
	for i in range(count):
		var v = load("res://scenes/Vehicle.tscn").instantiate()
		v.position = Vector3(rng.randf_range(-30,30), 1, rng.randf_range(-30,30))
		v.name_display = "Traffic " + str(i)
		if v:
			add_child(v)
			traffic_vehicles.append(v)
	print("World: spawned ", count, " traffic vehicles")

func set_region(name: String) -> void:
	region_name = name
	print("World region: ", name)