extends Node3D

@export var open_distance: float = 4.0
@export var open_time: float = 0.9

var closed_pos: Vector3

func _ready() -> void:
    closed_pos = global_transform.origin

func open() -> void:
    var target := closed_pos + Vector3(0, -open_distance, 0)
    var tween := create_tween()
    tween.tween_property(self, "global_transform:origin", target, open_time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
