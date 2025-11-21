extends Node2D

# 跟随的距离
@export var follow_distance: float = 80.0
# 跟随的平滑度
@export var follow_smoothness: float = 0.2

var target: Node2D = null

func set_follow_target(new_target: Node2D):
	target = new_target
	print("SnakeBody target set to: ", target)

func _process(delta: float) -> void:
	if target:
		# 计算目标方向
		var direction = (target.position - position).normalized()
		# 计算目标位置（保持一定距离）
		var target_position = target.position - direction * follow_distance
		# 平滑移动到目标位置
		position = position.lerp(target_position, follow_smoothness)
