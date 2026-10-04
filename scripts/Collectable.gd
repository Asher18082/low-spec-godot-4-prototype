extends Area3D

signal collected

var pool_owner: Node = null

func _ready() -> void:
    connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
    if body.is_in_group("player"):
        emit_signal("collected")
        if pool_owner and pool_owner.has_method("return_item"):
            pool_owner.call("return_item", self)
        else:
            queue_free()
