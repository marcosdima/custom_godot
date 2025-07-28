@tool
extends Component
class_name Text

const ENTER = '\n'

@export_multiline var content: String = "Text":
	set(value):
		content = value
		if Engine.is_editor_hint():
			self.set_contenedor()
@export_group("Font", "font_")
@export var font: FontFile = load("res://static/fonts/CaviarDreams.ttf")
@export var font_size: int = 16
@export var font_min_chars: int = 0

## [OVERWRITTEN] From: Component
func get_layout_type() -> Layout.LayoutType:
	return Layout.LayoutType.Grid


## [OVERWRITTEN] From: Component
func get_layout_spaces() -> Dictionary:
	var spaces = contenedor.layout.spaces.duplicate()
	
	for key in spaces:
		var c: Char = contenedor.get_ente_by_key(key)
		var space = spaces.get(key) as GridSpace
		
		var char_size = self.get_char_size(c)
		var ente_size = contenedor.layout.get_cell_size()
		
		space.column = c.column
		space.row = c.row
		
		var valid_size = ente_size != Vector2.ZERO
		var unit_x = char_size.x / ente_size.x
		var unit_y = char_size.y / ente_size.y
		
		space.column_span = unit_x if valid_size else 1
		space.row_span = unit_y if valid_size else 1
		
		if !valid_size: printerr("ente_size is ZERO!")
	
	return spaces


## [OVERWRITTEN] From: Component
func get_children_to_set() -> Array:
	var aux_children = []
	var text_config = self.parse_text_to_config() 
	
	var i = 0
	
	for r in range(text_config.size()):
		var len_r = text_config[r]
		for c in range(len_r):
			var char_aux = Char.new()
			char_aux.set_from(self, self.content[i], r, c, i)
			aux_children.append(char_aux)
			i += 1
		i += 1
	
	return aux_children


## [OVERWRITTEN] From: Component
func get_layout_config() -> Dictionary:
	var config = self.parse_text_to_config()
	return {
		Grid.COLUMNS: config.values().max(),
		Grid.ROWS: config.size()
	}


func parse_text_to_config() -> Dictionary:
	var char_count = 0
	var aux_line = 0
	
	var response = {}
	
	for c in self.content:
		if c != ENTER:
			char_count += 1
		else:
			## Add a line to respose.
			response[aux_line] = char_count
			aux_line += 1
			char_count = 0
	
	## Add a line to respose.
	response[aux_line] = char_count
	
	return response


func get_char_size(c: Char) -> Vector2:
	return self.font.get_string_size(
		c.value,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		font_size
	)


func get_metrics(s: float) -> int:
	@warning_ignore("narrowing_conversion")
	return self.font.get_ascent(s) - self.font.get_descent(s)
