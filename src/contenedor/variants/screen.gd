@tool
extends ScrollContainer
class_name Screen

@export var screen_size: Vector2 = Vector2.ZERO

var resize_timer = Timer.new()
var last_size = Vector2.ZERO

func _ready() -> void:
	self.set_viewport_area()
	
	resize_timer.wait_time = 0.3
	resize_timer.one_shot = true
	resize_timer.connect("timeout", set_viewport_area)
	self.add_child(resize_timer)
	var root = get_tree().get_root()
	root.size_changed.connect(resize_timer.start)
	
	await get_tree().process_frame
	
	self.set_viewport_area()


func _notification(what: int) -> void:
	if what == NOTIFICATION_EDITOR_POST_SAVE:
		self.set_viewport_area()


func set_viewport_area() -> void:
	global_position = Vector2.ZERO
	var _size_ = get_parent_area_size() if screen_size.is_zero_approx() or !Engine.is_editor_hint() else screen_size
	size = _size_
	for child in self.get_children():
		if child is Ente:
			child.set_area(Rect2(global_position, _size_))
