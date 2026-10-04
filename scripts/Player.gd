extends CharacterBody3D

@export var speed: float = 6.0
@export var jump_velocity: float = 6.0
@export var gravity: float = 20.0
@export var rotation_speed: float = 10.0

var _camera: Camera3D = null

func _ready() -> void:
    add_to_group("player")
    _camera = get_viewport().get_camera_3d()

func _physics_process(delta: float) -> void:
    var iv := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
    var move_vec := Vector3.ZERO

    if not _camera:
        _camera = get_viewport().get_camera_3d()

    if _camera:
        var forward := -_camera.global_transform.basis.z
        var right := _camera.global_transform.basis.x
        move_vec = (right * iv.x) + (forward * iv.y)
        move_vec.y = 0
        if move_vec.length() > 0.01:
            move_vec = move_vec.normalized() * speed
            var target_rot := atan2(move_vec.x, move_vec.z)
            rotation.y = lerp_angle(rotation.y, target_rot, clamp(rotation_speed * delta, 0.0, 1.0))
        else:
            move_vec = Vector3.ZERO
    else:
        var dir := Vector3(iv.x, 0.0, -iv.y)
        if dir.length() > 0.01:
            dir = dir.normalized() * speed
        else:
            dir = Vector3.ZERO
        move_vec = dir

    velocity.x = move_vec.x
    velocity.z = move_vec.z

    if not is_on_floor():
        velocity.y -= gravity * delta
    else:
        if Input.is_action_just_pressed("jump"):
            velocity.y = jump_velocity

    move_and_slide()
