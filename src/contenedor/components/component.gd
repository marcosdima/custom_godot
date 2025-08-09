extends Ente
class_name Component

const SCROLL = "SCROLL"
const CONTENEDOR = "CONTENEDOR"

@export var color: Color = Color.BLACK

var scroll: ScrollContainer:
	get():
		if !scroll:
			## Set scroll.
			scroll = ScrollContainer.new()
			scroll.name = SCROLL
			self.add_child_def(scroll)
			scroll.position = Vector2.ZERO
		return scroll
var contenedor: Contenedor

func _ready() -> void:
	## Set contenedor.
	contenedor = Contenedor.new()
	contenedor.name = CONTENEDOR
	contenedor.layout_type = self.get_layout_type()
	contenedor.entes = self.get_children_to_set() ## TODO: Fix set children routine.
	self.update_contenedor()
	
	if Engine.is_editor_hint():
		scroll.add_child.call_deferred(contenedor)
	else:
		scroll.add_child(contenedor)


## [OVERWRITTEN] From: Ente
func handle_resize() -> void:
	super()
	
	var area = self.get_area()
	scroll.size = area.size
	scroll.queue_sort()
	
	self.update_contenedor()
	contenedor.set_area(Rect2(Vector2.ZERO, area.size))
	#self.update_contenedor()


## [OVERWRITE] Get layout type to set contenedor.
func get_layout_type() -> Layout.LayoutType:
	return Layout.LayoutType.Pages


## [OVERWRITE] Set contenedor layout spaces.
func get_layout_spaces() -> Dictionary:
	return contenedor.layout.spaces


## [OVERWRITE] Get layout type to set contenedor.
func get_layout_config() -> Dictionary:
	return {} if !contenedor else contenedor.layout.config


## Get children to add to contenedor.
func get_children_to_set() -> Array:
	return self.get_children().filter(func(c): return c is Ente)


## Routine to update contenedor.
func update_contenedor() -> void:
	if Engine.is_editor_hint():
		contenedor.entes = self.get_children_to_set()
	contenedor.layout.spaces = self.get_layout_spaces()
	contenedor.layout.config = self.get_layout_config()
