extends Camera3D

@export var target_path: NodePath = NodePath("../Player")
@export var distance: float = 10.0
@export var min_distance: float = 5.0
@export var max_distance: float = 18.0
@export var sensitivity: float = 0.25
@export var min_pitch_deg: float = -10.0
@export var max_pitch_deg: float = 60.0
@export var rotate_player: bool = true
@export var player_rotate_speed: float = 10.0

var yaw: float = 0.0
var pitch: float = 0.0
onready var target: Node3D = get_node_or_null(target_path)

func _ready() -> void:
    if not target:
        target = get_node_or_null("../Player")
    if target:
        var dir = (global_transform.origin - (target.global_transform.origin + Vector3(0, 1, 0))).normalized()
        pitch = asin(clamp(dir.y, -1.0, 1.0))
        yaw = atan2(dir.x, dir.z)

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MouseButton.RIGHT):
        yaw -= deg2rad(event.relative.x * sensitivity)
        pitch = clamp(pitch - deg2rad(event.relative.y * sensitivity), deg2rad(min_pitch_deg), deg2rad(max_pitch_deg))
    elif event is InputEventMouseButton and event.pressed:
        if event.button_index == MouseButton.WHEEL_UP:
            distance = max(min_distance, distance - 1.0)
        elif event.button_index == MouseButton.WHEEL_DOWN:
            distance = min(max_distance, distance + 1.0)

func _process(delta: float) -> void:
    if not target:
        return
    var cpitch = clamp(pitch, deg2rad(min_pitch_deg), deg2rad(max_pitch_deg))
    var x = cos(cpitch) * sin(yaw)
    var y = sin(cpitch)
    var z = cos(cpitch) * cos(yaw)
    var dir = Vector3(x, y, z)
    var desired_pos = target.global_transform.origin + Vector3(0, 1, 0) + dir * distance
    global_transform.origin = global_transform.origin.lerp(desired_pos, clamp(12.0 * delta, 0.0, 1.0))
    look_at(target.global_transform.origin + Vector3(0, 1, 0), Vector3.UP)

    if rotate_player and target:
        var cur_y = target.rotation.y
        target.rotation.y = lerp_angle(cur_y, yaw, clamp(player_rotate_speed * delta, 0.0, 1.0))
