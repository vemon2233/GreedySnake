extends Node2D

@export var move_speed: float = 300.0
@export var body_scene: PackedScene  # 必须在编辑器赋值
@export var initial_body_count: int = 3

var body_parts: Array[Node2D] = []

func _ready() -> void:
	print("=== 蛇头初始化 ===")
	# 防御：检查父节点是否存在
	if not get_parent():
		print("❌ 蛇头未挂载到场景树！")
		return
	# 防御：检查body_scene是否赋值
	if not body_scene:
		print("❌ body_scene 未赋值！")
		return
	# 创建初始蛇身
	for i in range(initial_body_count):
		add_body_part()
	print("✅ 初始化完成，总蛇身数量: ", body_parts.size())

func _process(delta: float) -> void:
	var input_dir: Vector2 = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()
	position += input_dir * move_speed * delta

func add_body_part():
	if not body_scene or not get_parent():
		return
	
	var new_body = body_scene.instantiate()
	if not new_body:
		print("❌ 蛇身实例化失败")
		return
	
	var parent_node = get_parent()
	# 核心修复：添加节点时强制设置Owner（和父节点的Owner一致）
	add_child(new_body)
	new_body.owner = parent_node.owner  # 关键：让节点显示在场景树面板
	body_parts.append(new_body)
	
	# （保留你的位置/跟随逻辑）
	var offset = Vector2(-80 * body_parts.size(), 0)
	new_body.position = position + offset
	print("蛇身", body_parts.size(), "位置: ", new_body.position)
	
	if body_parts.size() == 1:
		new_body.set_follow_target(self)
	else:
		new_body.set_follow_target(body_parts[-2])
