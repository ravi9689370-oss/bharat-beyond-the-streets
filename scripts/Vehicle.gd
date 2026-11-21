extends RigidBody3D

class_name Vehicle

@export var engine_force: float = 2500.0
@export var brake_force: float = 1200.0
@export var steering_speed: float = 2.5
@export var max_steering_angle: float = 0.5
@export var max_speed: float = 35.0
@export var name_display: String = "Vehicle"

var steer_input: float = 0.0
var throttle_input: float = 0.0
var brake_input: float = 0.0
var is_driven: bool = false
var driver: Node3D = null
var current_steer: float = 0.0

func _ready() -> void:
	mass = 1200.0
	print("Vehicle ready: ", name_display, " at ", position, " mass=", mass)

func _physics_process(delta: float) -> void:
	if not is_driven:
		steer_input = 0.0
		throttle_input = 0.0
		brake_input = 0.0
		current_steer = lerp(current_steer, 0.0, delta * 4.0)
		return

	var target_steer = steer_input * max_steering_angle
	current_steer = lerp(current_steer, target_steer, delta * steering_speed)
	var yaw_torque = current_steer * 120.0
	apply_torque_impulse(Vector3(0, yaw_torque, 0))

	var forward = -global_transform.basis.z
	var speed = linear_velocity.length()
	var local_vel = global_transform.basis.inverse() * linear_velocity
	var can_accel = true
	if local_vel.z < -max_speed and throttle_input > 0:
		can_accel = false
	if can_accel and throttle_input != 0:
		apply_central_impulse(forward * (throttle_input * engine_force) * delta)

	if brake_input > 0:
		var damp = linear_velocity * (brake_input * brake_force) * delta
		apply_central_impulse(-damp)

	var drag = linear_velocity * 0.5 * delta
	apply_central_impulse(-drag)

func set_input(steer: float, throttle: float, brake: float):
	steer_input = steer
	throttle_input = throttle
	brake_input = brake

func enter(driver_node: Node3D) -> void:
	is_driven = true
	driver = driver_node
	print("Vehicle entered by ", driver_node.name)

func exit() -> void:
	is_driven = false
	driver = null
	print("Vehicle exited")

func get_speed() -> float:
	return linear_velocity.length()