extends Ente
class_name Contenedor

enum Placement {
	Start,
	Middle,
	End,
}



@export var sub_spaces: Dictionary
@export_group("Layout","")
@export var layout_type: Layout.LayoutType = Layout.LayoutType.Pages
@export var config: Dictionary
@export_group("Placement", "placement_")
@export var placement_axis_x: Placement:
	set(value):
		placement_axis_x = value
		self.set_layout()
@export var placement_axis_y: Placement: 
	set(value):
		placement_axis_y = value
		self.set_layout()
@export_subgroup("Spaces", "spaces_placement_")
@export var spaces_placement_x: Placement = Placement.Start:
	set(value):
		spaces_placement_x = value
		self.set_layout()
@export var spaces_placement_y: Placement = Placement.Start:
	set(value):
		spaces_placement_y = value
		self.set_layout()
@export_group("")
@export var contenedor_animations: Dictionary

var layout: Layout
var children: Array

## [OVERWRITE]  Start Ente in Editor procediments.
func editor_config() -> void:
	super()
	self.set_layout()
	self.children = self.get_children()
	ContenedorAnimator.set_contenedor_animations(self)


func _notification(what: int) -> void:
	if self.layout and what == NOTIFICATION_CHILD_ORDER_CHANGED:
		self.editor_config()


## Set layout configuration.
func set_layout() -> void:
	Layout.create(self)
	
	if self.config.is_empty():
		self.config = self.get_layout_config()
	
	if self.sub_spaces.is_empty():
		self.set_sub_spaces()
	
	for c in self.children:
		if c is Contenedor:
			c.layout.update_spaces()


## [OVERWRITE]  Do it to pre-set some configurations.
func get_layout_config() -> Dictionary:
	return self.layout.get_config()


## [OVERWRITE] Set spaces from contenedor children.
func set_sub_spaces() -> void:
	var aux = []
	
	for child in self.get_children():
		var k = child.name
		if !self.sub_spaces.has(k):
			var space = self.layout.get_new_space()
			self.sub_spaces[child.name] = space
		aux.append(k)

	for sub_k in self.sub_spaces:
		if !aux.has(sub_k):
			self.sub_spaces.erase(sub_k)


## [OVERWRITE] Set all as default.
func clean() -> void:
	self.config = {}
	self.sub_spaces = {}
	self.contenedor_animations = {}
	self.layout = null
	self.children = []
	super()


func get_start_offset(size_: Vector2) -> Vector2:
	var area = self.get_area()
	var start = area.position
	
	match self.placement_axis_x:
		Placement.Start: pass
		Placement.Middle: start.x += (area.size.x - size_.x) / 2
		Placement.End: start.x += area.size.x - size_.x
	
	match self.placement_axis_y:
		Placement.Start: pass
		Placement.Middle: start.y += (area.size.y - size_.y) / 2
		Placement.End: start.y += area.size.y - size_.y
	
	# TOFIX: It's a little off at y end.
	
	return start


func get_ente_by_key(k: String):
	for child in self.get_children():
		if child.name == k:
			return child
