extends Node3D

@export var goal: int = 3
@export var camera_smooth_speed: float = 6.0

var score: int = 0

@onready var player: Node = $Player
@onready var camera_3d: Camera3D = $Camera3D
@onready var hud: Node = $HUD
@onready var door: Node = $Door

func _ready() -> void:
    if player:
        player.add_to_group("player")

    for item in get_tree().get_nodes_in_group("collectable"):
        if item and item.has_signal("collected"):
            item.connect("collected", Callable(self, "_on_collected"))

    for name in ["Collectable1", "Collectable2", "Collectable3"]:
        if has_node(name):
            var it = get_node(name)
            if it and it.has_signal("collected"):
                it.connect("collected", Callable(self, "_on_collected"))

    if hud:
        hud.set_score(score)

    if player and camera_3d:
        camera_3d.look_at(player.global_transform.origin + Vector3(0, 1, 0), Vector3.UP)

func _physics_process(delta: float) -> void:
    if is_instance_valid(player) and is_instance_valid(camera_3d):
        var target_pos := player.global_transform.origin + Vector3(0, 6, 10)
        var cur := camera_3d.global_transform.origin
        var lerped := cur.linear_interpolate(target_pos, clamp(camera_smooth_speed * delta, 0.0, 1.0))
        camera_3d.global_transform = Transform3D(camera_3d.global_transform.basis, lerped)
        camera_3d.look_at(player.global_transform.origin + Vector3(0, 1, 0), Vector3.UP)

func _on_collected() -> void:
    score += 1
    print("Score: ", score)
    if hud:
        hud.set_score(score)
    if score >= goal:
        if is_instance_valid(door) and door.has_method("open"):
            door.call("open")
