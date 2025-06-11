extends Resource
class_name Space

@export var margin: Margin
@export var order: int = 0
var layout: Layout

func set_data(ly: Layout) -> void:
	self.layout = ly
	self.margin = Margin.new()
