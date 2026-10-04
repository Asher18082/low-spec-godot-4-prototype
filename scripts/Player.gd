extends CharacterBody3D

@export var speed: float = 6.0
@export var jump_velocity: float = 6.0
@export var gravity: float = 20.0

func _ready() -> void:
    add_to_group("player")

func _physics_process(delta: float) -> void:
    var iv := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
    var direction := Vector3(iv.x, 0.0, -iv.y)

    if direction.length() > 0.01:
        direction = direction.normalized() * speed
    else:
        direction = Vector3.ZERO

    velocity.x = direction.x
    velocity.z = direction.z

    if not is_on_floor():
        velocity.y -= gravity * delta
    else:
        if Input.is_action_just_pressed("jump"):
            velocity.y = jump_velocity

    move_and_slide()
