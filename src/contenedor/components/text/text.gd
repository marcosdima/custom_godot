@tool
extends Component
class_name Text

const ENTER = '\n'

@export_multiline var content: String = "Text":
	set(value):
		contenedor.clean_spaces()
		content = value
		self.handle_resize()
@export_group("Font", "font_")
@export var font: FontFile = load("res://static/fonts/CaviarDreams.ttf")
@export var font_size: int = 16
@export var font_min_chars: int = 0

## [OVERWRITTEN]
func get_children_to_add() -> Array:
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


func modificate_spaces() -> void:
	for key in contenedor.layout.spaces:
		var c: Char = contenedor.get_ente_by_key(key)
		var space = self.contenedor_spaces.get(key) as GridSpace
		
		var char_size = self.get_char_size(c)
		var ente_size = self.layout.get_cell_size()
		
		var unit_x = char_size.x / ente_size.x
		var unit_y = char_size.y / ente_size.y

		space.column_span = unit_x ## TODO: This messed up the view...
		space.row_span = unit_y
		
		space.column = c.column
		space.row = c.row


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
