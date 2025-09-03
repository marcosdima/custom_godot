extends Control
class_name ChildrenHandler

var scroll: ScrollContainer
var contenedor: Contenedor
var follow_resize: bool = false

func _init(set_contenedor: Contenedor) -> void:
	scroll = ScrollContainer.new()
	scroll.name = "Scroll"
	
	self.mouse_filter = Control.MOUSE_FILTER_PASS
	
	contenedor = set_contenedor
	name = "ChildHandler"
	contenedor.add_child(scroll)
	scroll.add_child(self)
	contenedor.connect_event(Ente.Event.Resize, set_scroll_area)


## Remove current children and set the new ones.
func set_children(children: Array) -> void:
	self.clean()
	for child in children:
		if !child.get_parent():
			self.add_child(child)


## Set area and emits resize.
func set_scroll_area() -> void:
	scroll.size = contenedor.get_area().size
	scroll.position = Vector2.ZERO


## Set the real size to show the scroll bar.
func set_internal_size(internal_size: Vector2) -> void:
	custom_minimum_size = internal_size
	
	## TODO: Remove? await get_tree().process_frame
	
	if follow_resize:
		scroll.scroll_horizontal = int(scroll.get_h_scroll_bar().max_value)
		scroll.scroll_vertical = int(scroll.get_v_scroll_bar().max_value)


## Remove its children.
func clean() -> void:
	for c in self.get_children():
		self.remove_child(c)
		c.queue_free()
