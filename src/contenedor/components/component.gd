extends Ente
class_name Component

const SCROLL = "SCROLL"
const CONTENEDOR = "CONTENEDOR"

@export var color: Color = Color.BLACK

var scroll: ScrollContainer
var contenedor: Contenedor

func _ready() -> void:
	super()
	
	scroll = ScrollContainer.new()
	scroll.name = SCROLL
	self.add_child(scroll)
	
	self.set_contenedor()
	child_entered_tree.connect(func(child): if child is Ente: contenedor.add_ente(child))


## [OVERWRITTEN] From: Ente
func handle_resize() -> void:
	super()
	
	var area = self.get_area()
	
	await get_tree().process_frame
	
	scroll.position = area.position
	scroll.custom_minimum_size = area.size
	scroll.queue_sort()
	
	contenedor.set_area(area)
	contenedor.layout.spaces = self.get_layout_spaces()


## [OVERWRITTEN] From: Ente
func set_children(children: Array) -> void:
	super(children)
	self.set_contenedor()


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
	return self.get_children()


## Routine to set contenedor.
func set_contenedor() -> void:
	if contenedor:
		scroll.remove_child.call_deferred(contenedor)
	
	contenedor = Contenedor.new()
	contenedor.name = CONTENEDOR
	contenedor.layout_type = self.get_layout_type()
	contenedor.add_entes(self.get_children_to_set())
	contenedor.layout.config = self.get_layout_config()
	
	if Engine.is_editor_hint():
		scroll.add_child.call_deferred(contenedor)
	else:
		scroll.add_child(contenedor)
