@tool
extends Component
class_name Text

@export_multiline var content: String:
	set(value):
		content = value
		self.clean()
@export_group("Font", "font_")
@export var font: FontFile = load("res://static/fonts/CaviarDreams.ttf")
@export var font_color: Color = Color.BLACK
@export var font_size: int = 16

var flag_writted: bool = false
var enter = '\n'
var max_font_size: float = 0
var max_line_size: int = 0

## [OVERWRITE] Get Layout type.
func get_layout_type() -> Layout.LayoutType:
	return Layout.LayoutType.Grid


## [OVERWRITE] Get chlidren.
func get_contenedor_children() -> Array:
	var aux_children = []
	var text_config = self.parse_text_to_config() 
	
	var i = 0
	
	for r in range(text_config.size()):
		var len_r = text_config[r]
		for c in range(len_r):
			var char_aux = Char.new()
			char_aux.set_from(self, self.content[i], r, c)
			aux_children.append(char_aux)
			i += 1
		i += 1
	
	return aux_children


## (Contenedor) [OVERWRITE]  Do it to pre-set some configurations.
func get_layout_config() -> Dictionary:
	var aux = super()
	var text_config = self.parse_text_to_config() 
	aux[Grid.COLUMNS] = self.max_line_size
	aux[Grid.ROWS] = text_config.size()
	return aux


## [OVERWRITE] Modifies spaces before update.
func set_spaces() -> void:
	for space_key in self.layout.get_sorted_spaces():
		var c: Char = self.get_ente_by_key(space_key)
		var space = self.sub_spaces[space_key]
		var grid = self.layout as Grid
		
		var char_size = self.get_char_size(c.value, self.get_font_size())
		var ente_size = grid.get_cell_size()
		
		var unit_x = char_size.x / ente_size.x
		var unit_y = char_size.y / ente_size.y
		
		var c_span =  unit_x - (unit_y * 0.1)
		var r_span = unit_y - (unit_y * 0.2)
	
		space.column_span = c_span
		space.row_span = r_span
		space.column = int(c.name.substr(0, 1))
		space.row = int(c.name.substr(1, 1))


func parse_text_to_config() -> Dictionary:
	var char_count = 0
	var aux_line = 0
	self.max_line_size = 0
	
	var response = {}
	
	for c in self.content:
		if c != enter:
			char_count += 1
		else:
			## Add a line to respose.
			response[aux_line] = char_count
			aux_line += 1
			if self.max_line_size < char_count:
				self.max_line_size = char_count
			char_count = 0
	
	## Add a line to respose.
	response[aux_line] = char_count
	if self.max_line_size < char_count:
		self.max_line_size = char_count
	
	return response


func get_font_size() -> float:
	if self.max_font_size == 0:
		var target = 'a'
		var aux_size = 1
		var char_size = self.get_char_size(target, aux_size)
		
		var av_size = self.layout.get_cell_size()
		
		var top = 200
		while char_size < av_size and top > 0:
			aux_size += 0.1 if av_size.x - char_size.x < 10 else 1.0
			char_size = self.get_char_size(target, aux_size)
			top -= 1
		self.max_font_size = aux_size
	
	return self.font_size * (self.max_font_size / 100)


func get_char_size(c: String, font_size_p: float) -> Vector2:
	return self.font.get_string_size(
		c,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		font_size_p as int
	)
