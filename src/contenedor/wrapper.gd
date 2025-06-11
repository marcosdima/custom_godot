extends Contenedor
class_name Wrapper

@export var layout_type: Layout.LayoutType = Layout.LayoutType.Pages

## [OVERWRITE] Get Layout type.
func get_layout_type() -> Layout.LayoutType:
	return layout_type
