@tool
extends ScrollContainer
class_name Screen

var resize_timer = Timer.new()
var last_size = Vector2.ZERO

func _ready() -> void:
	self.set_viewport_area()
	
	resize_timer.wait_time = 0.5
	resize_timer.one_shot = true
	resize_timer.connect("timeout", set_viewport_area)
	self.add_child(resize_timer)
	get_tree().get_root().size_changed.connect(
		func():
			resize_timer.start()
	)


func _notification(what: int) -> void:
	if what == NOTIFICATION_EDITOR_POST_SAVE:
		self.set_viewport_area()


func set_viewport_area() -> void:
	global_position = Vector2.ZERO
	var _size_ = get_tree().get_root().size
	var child = self.get_children()[0]
	custom_minimum_size = _size_
	child.set_area(Rect2(global_position, _size_))
