extends Resource
class_name Space

@export var margin: Margin
@export var order: int = 0
var layout: Layout

func set_data(ly: Layout) -> void:
	self.layout = ly
	self.margin = Margin.new()


func get_with_span(vec: Vector2) -> Vector2:
	var unit_x = vec.x
	var unit_y = vec.y
	return Vector2(unit_x, unit_y)
