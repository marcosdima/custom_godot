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
	mouse_filter = Control.MOUSE_FILTER_PASS
	
	if set_scroll:
		# Set ScrollContainer.
		scroll = ScrollContainer.new()
		scroll.name = SCROLL_NAME
		scroll.add_child(self)
		
		contenedor.add_child(scroll)
		contenedor.connect_event(Ente.Event.Resize, set_scroll_area)
	else:
		contenedor.add_child(self)


func _sort_children() -> void:
	pass


## Remove current children and set the new ones.
func set_children(children: Array) -> void:
	self.clean()
	for child in children:
		if !child.get_parent():
			child.mouse_filter = Control.MOUSE_FILTER_PASS
			self.add_child(child)


## Set area and emits resize.
func set_scroll_area() -> void:
	scroll.size = contenedor.get_area().size
	scroll.position = Vector2.ZERO


## Set the real size to show the scroll bar.
func set_internal_size(internal_size: Vector2) -> void:
	if scroll:
		custom_minimum_size = internal_size
		
		await get_tree().process_frame
		
		if follow_resize:
			scroll.scroll_horizontal = int(internal_size.x)
			scroll.scroll_vertical = int(internal_size.y)


## Remove its children.
func clean() -> void:
	for c in self.get_children():
		self.remove_child(c)
		c.queue_free()
