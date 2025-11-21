extends Node2D

@export var move_speed: float = 300.0
var snake_head: Node2D  # 子节点引用

# 节点就绪时获取子节点（只执行一次，效率高）
func _ready() -> void:
	# 路径格式："子节点名称"（如果是多级子节点，写 "父节点/子节点"）
	snake_head = $SnakeHead  # $ 是 get_node() 的简写
	
	# 容错
	if not snake_head:
		print("未找到 SnakeHead 子节点！")

func _process(delta: float) -> void:
	if not snake_head:
		return
	
	var input_dir = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()
	
	snake_head.position += input_dir * move_speed * delta
