extends Area3D

signal collected

var pool_owner: Node = null

@export var rotate_speed: float = 90.0 # degrees per second
@export var float_amp: float = 0.15
@export var float_speed: float = 2.0

var _base_y: float = 0.0
var _mesh: MeshInstance3D

func _ready() -> void:
    connect("body_entered", Callable(self, "_on_body_entered"))
    _mesh = get_node_or_null("GemMesh")
    _base_y = global_transform.origin.y

func _process(delta: float) -> void:
    if _mesh:
        _mesh.rotate_y(deg2rad(rotate_speed * delta))
    # simple float/bob effect for the whole Area3D
    var off = sin(OS.get_ticks_msec() / 1000.0 * float_speed) * float_amp
    var t: Transform3D = global_transform
    t.origin.y = _base_y + off
    global_transform = t

func _on_body_entered(body: Node) -> void:
    if body.is_in_group("player"):
        emit_signal("collected")
        if pool_owner and pool_owner.has_method("return_item"):
            pool_owner.call("return_item", self)
        else:
            queue_free()
