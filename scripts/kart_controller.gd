extends CharacterBody3D

const HANDLING_CONFIG_PATH := "res://configs/kart_handling.cfg"

@onready var _visual: Node3D = $Body

var max_speed_mps: float
var acceleration_mps2: float
var braking_mps2: float
var rolling_resistance_mps2: float
var turn_rate_rad_per_second: float
var gravity_mps2: float
var sphere_radius_m: float
var _speed_mps: float = 0.0

func _ready() -> void:
	if not _load_handling_config():
		set_physics_process(false)

func _physics_process(delta: float) -> void:
	var throttle := Input.get_action_strength("accelerate")
	var brake_input := Input.get_action_strength("brake")

	if throttle > 0.0:
		_speed_mps = move_toward(_speed_mps, max_speed_mps, acceleration_mps2 * throttle * delta)
	elif brake_input > 0.0:
		_speed_mps = move_toward(_speed_mps, 0.0, braking_mps2 * brake_input * delta)
	else:
		_speed_mps = move_toward(_speed_mps, 0.0, rolling_resistance_mps2 * delta)

	var steering := Input.get_axis("steer_left", "steer_right")
	var steering_strength := clampf(absf(_speed_mps) / max_speed_mps, 0.0, 1.0)
	rotate_y(-steering * turn_rate_rad_per_second * steering_strength * delta)

	var forward := -global_basis.z
	velocity.x = forward.x * _speed_mps
	velocity.z = forward.z * _speed_mps
	if is_on_floor():
		velocity.y = 0.0
	else:
		velocity.y -= gravity_mps2 * delta

	move_and_slide()
	_visual.rotate_object_local(Vector3.RIGHT, -_speed_mps * delta / sphere_radius_m)

func _load_handling_config() -> bool:
	var config := ConfigFile.new()
	var load_error := config.load(HANDLING_CONFIG_PATH)
	if load_error != OK:
		push_error(
			"Could not load kart handling config '%s': %s"
			% [HANDLING_CONFIG_PATH, error_string(load_error)]
		)
		return false

	max_speed_mps = _read_number(config, "max_speed_mps")
	acceleration_mps2 = _read_number(config, "acceleration_mps2")
	braking_mps2 = _read_number(config, "braking_mps2")
	rolling_resistance_mps2 = _read_number(config, "rolling_resistance_mps2")
	turn_rate_rad_per_second = _read_number(config, "turn_rate_rad_per_second")
	gravity_mps2 = _read_number(config, "gravity_mps2")
	sphere_radius_m = _read_number(config, "sphere_radius_m")

	if (
		not is_finite(max_speed_mps)
		or not is_finite(acceleration_mps2)
		or not is_finite(braking_mps2)
		or not is_finite(rolling_resistance_mps2)
		or not is_finite(turn_rate_rad_per_second)
		or not is_finite(gravity_mps2)
		or not is_finite(sphere_radius_m)
	):
		return false

	if (
		max_speed_mps <= 0.0
		or acceleration_mps2 <= 0.0
		or braking_mps2 <= 0.0
		or rolling_resistance_mps2 < 0.0
		or turn_rate_rad_per_second <= 0.0
		or gravity_mps2 <= 0.0
		or sphere_radius_m <= 0.0
	):
		push_error(
			"Handling values must be positive; rolling_resistance_mps2 may be zero."
		)
		return false

	return true

func _read_number(config: ConfigFile, key: String) -> float:
	var value: Variant = config.get_value("handling", key, null)
	if typeof(value) != TYPE_INT and typeof(value) != TYPE_FLOAT:
		push_error(
			"Handling config '%s' requires a numeric value for '%s'."
			% [HANDLING_CONFIG_PATH, key]
		)
		return -1.0

	var number := float(value)
	if not is_finite(number):
		push_error("Handling config value '%s' must be finite." % key)
		return -1.0

	return number
