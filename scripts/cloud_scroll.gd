extends Sprite2D

@export var cloud_speeds: Array[float] = [15.0, 25.0, 10.0, 30.0]
@export var screen_wrap_margin: float = 600.0
@export var wrap_distance: float = 1200.0


func _process(delta: float) -> void:
	for i in range(min(4, get_child_count())):
		var cloud = get_child(i)
		cloud.position.x -= cloud_speeds[i] * delta
		
		if cloud.position.x < -screen_wrap_margin:
			cloud.position.x += wrap_distance
