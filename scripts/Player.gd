extends CharacterBody3D

class_name Player

@export var walk_speed: float = 3.5
@export var run_speed: float = 6.0
@export var sprint_speed: float = 9.0
@export var jump_velocity: float = 5.5
@export var gravity: float = 19.6
@export var air_control: float = 0.5
@export var friction: float = 4.0
@export var rotation_speed: float = 8.0

var move_velocity: Vector3 = Vector3.ZERO
var is_sprinting: bool = false
var is_grounded: bool = false
var current_speed: float = 0.0
var in_vehicle: bool = false
var vehicle_node: Node3D = null
var input_dir: Vector2 = Vector2.ZERO

const INTERACTION_DISTANCE: float = 3.0

func _ready() -> void:
	if get_child_count() == 0:
		var capsule = CapsuleMesh.new()
		capsule.radius = 0.3
		capsule.height = 1.6
		var mi = MeshInstance3D.new()
		mi.mesh = capsule
		mi.name = "PlayerVisual"
		add_child(mi)
		var col = CollisionShape3D.new()
		col.shape = CapsuleShape3D.new()
		col.shape.radius = 0.3
		col.shape.height = 1.6
		add_child(col)
	print("Player ready at ", position)

func _physics_process(delta: float) -> void:
	if in_vehicle:
		move_velocity = Vector3.ZERO
		move_and_slide()
		return

	is_grounded = is_on_floor()
	var target_speed: float = walk_speed
	if is_sprinting:
		target_speed = sprint_speed
	elif input_dir.length() > 0.1:
		if Input.is_action_pressed("sprint"):
			target_speed = sprint_speed
		else:
			target_speed = run_speed

	if is_grounded and Input.is_action_just_pressed("jump"):
		move_velocity.y = jump_velocity

	if not is_grounded:
		move_velocity.y -= gravity * delta

	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction.length() > 0:
		current_speed = lerp(current_speed, target_speed, delta * 8.0)
		look_at(position + direction, Vector3.UP)
		rotation.y = lerp_angle(rotation.y, (position + direction - position).angle_to_y(), delta * rotation_speed)
		move_velocity.x = direction.x * current_speed
		move_velocity.z = direction.z * current_speed
	else:
		if not is_grounded:
			move_velocity.x = lerp(move_velocity.x, direction.x * current_speed * air_control, delta * 4.0)
			move_velocity.z = lerp(move_velocity.z, direction.z * current_speed * air_control, delta * 4.0)
		move_velocity.x = lerp(move_velocity.x, 0.0, delta * friction)
		move_velocity.z = lerp(move_velocity.z, 0.0, delta * friction)

	velocity = move_velocity
	move_and_slide()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		_check_interaction()

func _check_interaction() -> void:
	var space_state = get_world_3d().direct_space_state
	var from = global_position + Vector3(0, 1, 0)
	var to = from + (-global_transform.basis.z * INTERACTION_DISTANCE)
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	if result.has("collider"):
		var collider = result.collider
		if collider.has_method("interact"):
			collider.interact()
		elif collider.has_method("enter_vehicle"):
			enter_vehicle(collider)

func enter_vehicle(vehicle: Node3D) -> void:
	in_vehicle = true
	vehicle_node = vehicle
	set_physics_process(false)
	print("Entered vehicle: ", vehicle.name)

func exit_vehicle() -> void:
	if vehicle_node:
		global_position = vehicle_node.global_position + Vector3(2, 0, 0)
		vehicle_node = null
	in_vehicle = false
	set_physics_process(true)
	print("Exited vehicle")

func set_input(direction: Vector2) -> void:
	input_dir = direction

func set_sprint(val: bool) -> void:
	is_sprinting = val