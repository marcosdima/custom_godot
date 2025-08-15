extends Control
class_name ChildrenHandler

var scroll: ScrollContainer

func _init(e: Ente) -> void:
	## Set name.
	name = e.name + " - " + "ChildHandler"
	
	## Set scroll.
	scroll = ScrollContainer.new()
	scroll.name = e.name + " - " + "Scroll"
	
	
	## Set 
	e.add_child(scroll)
	scroll.add_child(self)
	e.connect_event(
		Ente.Event.Resize,
		func():
			self.set_scroll_area(e)
	)


## Remove current children and set the new ones.
func set_children(children: Array) -> void:
	self.clean()
	for child in children:
		if !child.get_parent():
			self.add_child(child)


## Set area and emits resize.
func set_scroll_area(e: Ente) -> void:
	var area = e.get_area()
	scroll.size = area.size
	size = area.size


## Set the real size to show the scroll bar.
func set_internal_size(internal_size: Vector2) -> void:
	custom_minimum_size = internal_size
	
	await get_tree().process_frame
	
	scroll.scroll_horizontal = int(scroll.get_h_scroll_bar().max_value)
	scroll.scroll_vertical = int(scroll.get_v_scroll_bar().max_value)


## Remove its children.
func clean() -> void:
	for c in self.get_children():
		self.remove_child(c)
		c.queue_free()
