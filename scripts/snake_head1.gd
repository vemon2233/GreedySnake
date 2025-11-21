extends Node2D

@export var move_speed: float = 300.0
@export var body_scene: PackedScene
@export var initial_body_count: int = 3

var body_parts: Array[Node2D] = []

func _ready() -> void:
	print("SnakeHead ready, creating bodies...")
	# 创建初始蛇身
	for i in range(initial_body_count):
		add_body_part()
	print("Created ", body_parts.size(), " body parts")

func _process(delta: float) -> void:
	var input_dir: Vector2 = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()
	
	# 移动蛇头
	position += input_dir * move_speed * delta

func add_body_part():
	if body_scene:
		var new_body = body_scene.instantiate()
		
		# 将蛇身添加到场景树中（作为蛇头的兄弟节点）
		print(get_parent())
		get_parent().add_child(new_body)
		add_child(new_body)
		body_parts.append(new_body)
		
		# 设置初始位置
		if body_parts.size() == 1:
			new_body.position = position - Vector2(80, 0)
		else:
			new_body.position = body_parts[-2].position - Vector2(80, 0)
		
		# 设置蛇身的跟随目标
		if body_parts.size() == 1:
			new_body.set_follow_target(self)  # 第一个蛇身跟随蛇头
		else:
			new_body.set_follow_target(body_parts[-2])  # 后续蛇身跟随前一个蛇身
		
		print("Added body ", body_parts.size(), " to scene tree")
