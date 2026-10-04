extends Node

@export var collectable_scene: PackedScene
@export var pool_size: int = 10

var free_items: Array = []

func _ready() -> void:
    if collectable_scene:
        for i in pool_size:
            var inst = collectable_scene.instantiate()
            inst.visible = false
            inst.pool_owner = self
            add_child(inst)
            free_items.append(inst)

func get_item_at(pos: Vector3) -> Node:
    var item: Node = null
    if free_items.size() > 0:
        item = free_items.pop_back()
    else:
        item = collectable_scene.instantiate()
        item.pool_owner = self
        add_child(item)
    item.global_transform.origin = pos
    item.visible = true
    if item.has_method("set_monitoring"):
        item.set("monitoring", true)
    return item

func return_item(item: Node) -> void:
    item.visible = false
    item.global_transform.origin = Vector3(-1000, -1000, -1000)
    free_items.append(item)
