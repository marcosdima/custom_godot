extends Control
class_name ChildrenHandler

const NAME = "ChildHandler"
const SCROLL_NAME = "Scroll"

var scroll: ScrollContainer
var contenedor: Contenedor

var follow_resize: bool = false

func _init(contenedor_: Contenedor, set_scroll: bool = false) -> void:
	contenedor = contenedor_
	name = NAME
	if set_scroll:
		scroll = ScrollContainer.new()
		scroll.name = SCROLL_NAME
		contenedor.add_child(scroll)
		scroll.add_child(self)
		contenedor.connect_event(Ente.Event.Resize, set_scroll_area)
	else:
		contenedor.add_child(self)

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
	if scroll:
		custom_minimum_size = internal_size
		if follow_resize:
			scroll.scroll_horizontal = int(scroll.get_h_scroll_bar().max_value)
			scroll.scroll_vertical = int(scroll.get_v_scroll_bar().max_value)


## Remove its children.
func clean() -> void:
	for c in self.get_children():
		self.remove_child(c)
		c.queue_free()
