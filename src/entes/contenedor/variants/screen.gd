@tool
extends ScrollContainer
class_name Screen

@export var screen_size: Vector2 = Vector2.ZERO

var resize_timer: ManualTimer
var last_size = Vector2.ZERO

func _ready() -> void:
	resize_timer = ManualTimer.new(0.2, self.set_viewport_area)
	var root = get_tree().get_root()
	root.size_changed.connect(resize_timer.start)
	self.set_viewport_area()


func _notification(what: int) -> void:
	if what == NOTIFICATION_EDITOR_POST_SAVE:
		self.set_viewport_area()


func set_viewport_area() -> void:
	var _size_ = get_viewport_rect().size if screen_size.is_zero_approx() or !Engine.is_editor_hint() else screen_size
	custom_minimum_size = _size_
	
	# If the window is resized, the parent position is moved.
	var parent = get_parent()
	if parent is Control:
		parent.position = Vector2.ZERO
	
	await get_tree().process_frame
	
	var principal_child = self.get_children().front()
	principal_child.set_area(Rect2(Vector2.ZERO, _size_))
