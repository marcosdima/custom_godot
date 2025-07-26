@tool
extends Ente
class_name Component

const SCROLL = "SCROLL"
const CONTENEDOR = "CONTENEDOR"

@export_group("Contenedor", "contenedor")
@export var spaces: Dictionary:
	get():
		if contenedor and (!spaces or spaces.is_empty()):
			spaces = contenedor.layout.spaces
		return spaces
@export var config: Dictionary:
	get():
		if contenedor and (!config or config.is_empty()):
			config = contenedor.layout.config
		return config
@export var layout_type: Layout.LayoutType:
	set(value):
		layout_type = value
		if contenedor:
			contenedor.layout_type = layout_type
			spaces = contenedor.layout.spaces
			config = contenedor.layout.config

var scroll: ScrollContainer
var contenedor: Contenedor

func _ready() -> void:
	scroll = ScrollContainer.new()
	scroll.name = SCROLL
	self.add_child(scroll)
	self.set_contenedor()
	child_entered_tree.connect(set_contenedor)


## [OVERWRITTEN] From: Ente
func handle_resize() -> void:
	super()
	contenedor.layout.spaces = spaces
	contenedor.layout.config = config
	self.recalcular_scroll()


## [OVERWRITE] Get children to add to contenedor.
func get_children_to_add() -> Array:
	var entes = self.get_children()
	for e in self.get_children():
		if e is Ente and !Engine.is_editor_hint():
			self.remove_child(e)
	return entes


func set_contenedor() -> void:
	if contenedor:
		scroll.remove_child.call_deferred(contenedor)
	
	var entes = self.get_children_to_add()
	
	contenedor = Contenedor.new()
	contenedor.name = CONTENEDOR
	contenedor.layout_type = layout_type
	contenedor.layout.spaces = spaces
	contenedor.layout.config = config
	contenedor.add_components(entes)
	
	if Engine.is_editor_hint():
		scroll.add_child.call_deferred(contenedor)
	else:
		scroll.add_child(contenedor)
	


func recalcular_scroll():
	await get_tree().process_frame
	var area = self.get_area()
	scroll.position = area.position
	scroll.custom_minimum_size = area.size
	scroll.queue_sort()
	contenedor.set_area(area)
