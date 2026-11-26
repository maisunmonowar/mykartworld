extends CharacterBody3D

const HANDLING_CONFIG_PATH := "res://configs/kart_handling.cfg"
const TONE_SAMPLE_RATE := 22050
const TONE_SAMPLE_COUNT := 4410
const TONE_BASE_FREQUENCY_HZ := 220.0
const TONE_AMPLITUDE := 8000.0
const DRIFT_TIER_NONE := 0
const DRIFT_TIER_BLUE := 1
const DRIFT_TIER_ORANGE := 2
const DRIFT_TIER_PURPLE := 3

@onready var _visual: Node3D = $Body
@onready var _drift_sparks: CPUParticles3D = $DriftSparks
@onready var _drift_status: Label = $"../DriftHUD/Status"
@onready var _drift_tone: AudioStreamPlayer3D = $DriftTone

var max_speed_mps: float
var acceleration_mps2: float
var braking_mps2: float
var rolling_resistance_mps2: float
var turn_rate_rad_per_second: float
var gravity_mps2: float
var sphere_radius_m: float
var minimum_drift_speed_mps: float
var orange_charge_seconds: float
var purple_charge_seconds: float
var minimum_pitch_scale: float
var maximum_pitch_scale: float
var _speed_mps: float = 0.0
var _drift_active: bool = false
var _drift_charge_seconds: float = 0.0
var _drift_tier: int = DRIFT_TIER_NONE

func _ready() -> void:
	if not _load_tuning_config():
		set_physics_process(false)
		return

	_drift_tone.stream = _create_drift_tone()
	_drift_status.text = "HOLD SPACE / RB WHILE MOVING TO DRIFT"

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
	_update_drift_charge(delta)

func _load_tuning_config() -> bool:
	var config := ConfigFile.new()
	var load_error := config.load(HANDLING_CONFIG_PATH)
	if load_error != OK:
		push_error(
			"Could not load kart handling config '%s': %s"
			% [HANDLING_CONFIG_PATH, error_string(load_error)]
		)
		return false

	max_speed_mps = _read_number(config, "handling", "max_speed_mps")
	acceleration_mps2 = _read_number(config, "handling", "acceleration_mps2")
	braking_mps2 = _read_number(config, "handling", "braking_mps2")
	rolling_resistance_mps2 = _read_number(config, "handling", "rolling_resistance_mps2")
	turn_rate_rad_per_second = _read_number(config, "handling", "turn_rate_rad_per_second")
	gravity_mps2 = _read_number(config, "handling", "gravity_mps2")
	sphere_radius_m = _read_number(config, "handling", "sphere_radius_m")
	minimum_drift_speed_mps = _read_number(config, "drift", "minimum_speed_mps")
	orange_charge_seconds = _read_number(config, "drift", "orange_charge_seconds")
	purple_charge_seconds = _read_number(config, "drift", "purple_charge_seconds")
	minimum_pitch_scale = _read_number(config, "drift", "minimum_pitch_scale")
	maximum_pitch_scale = _read_number(config, "drift", "maximum_pitch_scale")

	if (
		not is_finite(max_speed_mps)
		or not is_finite(acceleration_mps2)
		or not is_finite(braking_mps2)
		or not is_finite(rolling_resistance_mps2)
		or not is_finite(turn_rate_rad_per_second)
		or not is_finite(gravity_mps2)
		or not is_finite(sphere_radius_m)
		or not is_finite(minimum_drift_speed_mps)
		or not is_finite(orange_charge_seconds)
		or not is_finite(purple_charge_seconds)
		or not is_finite(minimum_pitch_scale)
		or not is_finite(maximum_pitch_scale)
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
		or minimum_drift_speed_mps <= 0.0
		or minimum_drift_speed_mps >= max_speed_mps
		or orange_charge_seconds <= 0.0
		or purple_charge_seconds <= orange_charge_seconds
		or minimum_pitch_scale <= 0.0
		or maximum_pitch_scale <= minimum_pitch_scale
	):
		push_error(
			"Invalid tuning config: values must be positive, except rolling resistance; "
			+ "drift speed must be below top speed, and purple charge and maximum pitch "
			+ "must exceed their preceding values."
		)
		return false

	return true

func _read_number(config: ConfigFile, section: String, key: String) -> float:
	var value: Variant = config.get_value(section, key, null)
	if typeof(value) != TYPE_INT and typeof(value) != TYPE_FLOAT:
		push_error(
			"Handling config '%s' requires a numeric value for '%s/%s'."
			% [HANDLING_CONFIG_PATH, section, key]
		)
		return -1.0

	var number := float(value)
	if not is_finite(number):
		push_error("Handling config value '%s/%s' must be finite." % [section, key])
		return -1.0

	return number

func _update_drift_charge(delta: float) -> void:
	var can_drift := Input.is_action_pressed("drift") and _speed_mps >= minimum_drift_speed_mps
	if not can_drift:
		if _drift_active:
			_end_drift_charge()
		return

	if not _drift_active:
		_drift_active = true
		_drift_charge_seconds = 0.0
		_drift_sparks.emitting = true
		_drift_sparks.restart()
		_drift_tone.pitch_scale = minimum_pitch_scale
		_drift_tone.play()

	_drift_charge_seconds += delta
	var next_tier := _get_drift_tier(_drift_charge_seconds)
	if next_tier != _drift_tier:
		_drift_tier = next_tier
		_set_drift_feedback(_drift_tier)

	var charge_progress := clampf(_drift_charge_seconds / purple_charge_seconds, 0.0, 1.0)
	_drift_tone.pitch_scale = lerpf(minimum_pitch_scale, maximum_pitch_scale, charge_progress)
	_drift_status.text = "DRIFT %s  |  %.1f s" % [
		_get_drift_tier_name(_drift_tier),
		_drift_charge_seconds
	]

func _get_drift_tier(charge_seconds: float) -> int:
	if charge_seconds >= purple_charge_seconds:
		return DRIFT_TIER_PURPLE
	if charge_seconds >= orange_charge_seconds:
		return DRIFT_TIER_ORANGE
	return DRIFT_TIER_BLUE

func _get_drift_tier_name(tier: int) -> String:
	match tier:
		DRIFT_TIER_BLUE:
			return "BLUE"
		DRIFT_TIER_ORANGE:
			return "ORANGE"
		DRIFT_TIER_PURPLE:
			return "PURPLE"
	return "NONE"

func _set_drift_feedback(tier: int) -> void:
	var tier_color: Color
	match tier:
		DRIFT_TIER_BLUE:
			tier_color = Color(0.2, 0.65, 1.0, 1.0)
			_drift_sparks.amount = 10
			_drift_sparks.initial_velocity_min = 1.5
			_drift_sparks.initial_velocity_max = 2.5
		DRIFT_TIER_ORANGE:
			tier_color = Color(1.0, 0.48, 0.08, 1.0)
			_drift_sparks.amount = 18
			_drift_sparks.initial_velocity_min = 2.5
			_drift_sparks.initial_velocity_max = 3.8
		DRIFT_TIER_PURPLE:
			tier_color = Color(0.78, 0.28, 1.0, 1.0)
			_drift_sparks.amount = 28
			_drift_sparks.initial_velocity_min = 3.5
			_drift_sparks.initial_velocity_max = 5.0
	_drift_sparks.color = tier_color
	_drift_status.modulate = tier_color

func _end_drift_charge() -> void:
	_drift_active = false
	_drift_charge_seconds = 0.0
	_drift_tier = DRIFT_TIER_NONE
	_drift_sparks.emitting = false
	_drift_tone.stop()
	_drift_status.text = "HOLD SPACE / RB WHILE MOVING TO DRIFT"
	_drift_status.modulate = Color.WHITE

func _create_drift_tone() -> AudioStreamWAV:
	var samples := PackedByteArray()
	samples.resize(TONE_SAMPLE_COUNT * 2)
	for sample_index in range(TONE_SAMPLE_COUNT):
		var phase := TAU * TONE_BASE_FREQUENCY_HZ * float(sample_index) / TONE_SAMPLE_RATE
		samples.encode_s16(sample_index * 2, roundi(sin(phase) * TONE_AMPLITUDE))

	var tone := AudioStreamWAV.new()
	tone.format = AudioStreamWAV.FORMAT_16_BITS
	tone.mix_rate = TONE_SAMPLE_RATE
	tone.data = samples
	tone.loop_mode = AudioStreamWAV.LOOP_FORWARD
	tone.loop_begin = 0
	tone.loop_end = TONE_SAMPLE_COUNT
	return tone
