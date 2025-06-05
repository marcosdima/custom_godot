extends Ente
class_name Contenedor

enum Placement {
	Start,
	Middle,
	End,
}

@export_group("Placement", "placement_")
@export var placement_axis_x: Placement = Placement.Start
@export var placement_axis_y: Placement = Placement.Start

@export_group("")
@export var layout_type: Layout.LayoutType:
	set(value):
		self.sub_spaces = {}
		self.config = {}
		layout_type = value
		self.set_layout()
@export var sub_spaces: Dictionary:
	set(value):
		sub_spaces = value

@export var config: Dictionary
@export var contenedor_animations: Dictionary

var layout: Layout

func initialization_routine() -> void:
	super()
	self.set_layout()
	ContenedorAnimator.set_contenedor_animations(self)


## Set layout configuration.
func set_layout() -> void:
	Layout.create(self)
	
	if self.config.is_empty():
		self.config = self.get_layout_config()
	
	if self.sub_spaces.is_empty():
		self.set_sub_spaces()
	else:
		self.layout.update_spaces()


## [OVERWRITE]  Do it to pre-set some configurations.
func get_layout_config() -> Dictionary:
	return self.layout.get_config()


## [OVERWRITE] Set spaces from contenedor children.
func set_sub_spaces() -> void:
	var children = self.get_children()
	
	for child in children:
		self.add_space(child)


## [OVERWRITE] Set all as default.
func clean() -> void:
	self.config = {}
	self.sub_spaces = {}
	self.contenedor_animations = {}
	super()


func add_space(e: Ente) -> void:
	if !self.sub_spaces.has(str(e.name)):
		var space = self.layout.get_new_space()
		self.sub_spaces[e.name] = space


func _notification(what: int) -> void:
	super(what)
	
	if NOTIFICATION_CHILD_ORDER_CHANGED == what:
		pass#self.set_sub_spaces()


func get_ente_by_key(k: String):
	for child in self.get_children():
		if child.name == k:
			return child
	#Printea.print(self, "Ente [" + k + "] not found")
