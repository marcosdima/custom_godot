@tool
extends Element

class_name Contenedor

enum LayoutType {
	Flow,
	Rail,
}
static var paths = {
	LayoutType.Flow: "res://src/contenedor/layouts/types/flow/flow_layout.gd",
	LayoutType.Rail: "res://src/contenedor/layouts/types/rail/rail_layout.gd",
}
@export var layout_type: LayoutType = LayoutType.Flow
@export var margin: int = 0
@export var space_between: int = 0

var layout: Layout = null

## With [param layout_type] gets an script and instantiate a layout, to handle content moving.
func handle_resize():
	if self.paths:
		var script = load(self.paths[self.layout_type])
		
		if script:
			var instance = script.new()
		
			if instance is Layout:
				instance.set_contenedor(self)
				self.layout = instance
			else:
				push_error("Instance should be Layout!")
			
			self.layout.move_contenedor_elements()


## Set [param position].
func set_element_position(p: Vector2) -> void:
	self.position = p


## Elements getter.
func get_elements() -> Array[Element]:
	var result: Array[Element] = []
	
	for child in self.get_direct_children():
		if child is Element:
			result.append(child as Element)
	
	return result


## Retrieves margins.
func get_margins() -> Vector2:
	# Each margin unit represents a 100th part of the total size.
	var margin_y = (self.size.y / 100) * self.margin
	var margin_x = (self.size.x / 100) * self.margin
	
	return Vector2(margin_x, margin_y)


## Retrieves [params Contenedor] size minus margins.
func get_available_size() -> Vector2:
	var m = self.get_margins() * 2
	return self.size - m


## Retrieves [params Contenedor] position plus margins.
func get_current_position() -> Vector2:
	return self.position + self.get_margins()


## Retrieves space between elements.
func get_space() -> Vector2:
	# Each margin unit represents a 100th part of the total size.
	var space_y = (self.size.y / 100) * self.space_between
	var space_x = (self.size.x / 100) * self.space_between
	
	return Vector2(space_x, space_y)
