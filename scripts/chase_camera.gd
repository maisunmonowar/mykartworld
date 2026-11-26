extends Camera3D

@export var target_path: NodePath
@export var follow_height: float = 18.0
@export var follow_distance: float = 28.0
@export var look_height: float = 0.9
@export var smoothing_speed: float = 5.0

var _target: Node3D

func _ready() -> void:
	_target = get_node_or_null(target_path) as Node3D
	if _target == null:
		push_error("Chase camera requires a valid Node3D target: %s" % target_path)

func _process(delta: float) -> void:
	if _target == null:
		return

	var offset := _target.global_basis * Vector3(0.0, follow_height, follow_distance)
	var desired_position := _target.global_position + offset
	global_position = global_position.lerp(desired_position, 1.0 - exp(-smoothing_speed * delta))
	look_at(_target.global_position + Vector3.UP * look_height, Vector3.UP)
