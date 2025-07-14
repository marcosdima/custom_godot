@tool
extends Component
class_name Text

const ENTER = '\n'

@export_multiline var content: String = "Text":
	set(value):
		content = value
@export_group("Font", "font_")
@export var font: FontFile = load("res://static/fonts/CaviarDreams.ttf")
@export var font_size: int = 100
@export var min_chars: int = 0

var max_font_size: float = 0

## [OVERWRITTEN] From: Component -> Contenedor -> Ente
func handle_resize() -> void:
	super()
	self.set_max_font_size()


## [OVERWRITTEN]
func get_layout_type() -> Layout.LayoutType:
	return Layout.LayoutType.Grid


## [OVERWRITTEN]
func get_component_children() -> Array:
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


## [OVERWRITTEN]
func modify_default_layout_config() -> void:
	var text_config = self.parse_text_to_config()
	var max = text_config.values().max()
	self.layout.config = {
		Grid.COLUMNS: max if self.min_chars < max else self.min_chars,
		Grid.ROWS: text_config.size()
	}


## [OVERWRITTEN]
func modificate_space(key: String) -> void:
	var c: Char = self.get_ente_by_key(key)
	var space = self.contenedor_spaces.get(key) as GridSpace
	#if !self.contenedor_config.is_empty() and c:
	var char_size = self._calculate_size(c.value, self.get_font_size())
	var ente_size = self.layout.get_cell_size()
	
	var unit_x = char_size.x / ente_size.x
	var unit_y = char_size.y / ente_size.y

	space.column_span = unit_x ## TODO: This messed up the view...
	space.row_span = unit_y * 0.8
	
	space.column = int(c.name.substr(1, 1))
	space.row = int(c.name.substr(0, 1))


func set_content(new_content: String) -> void:
	self.content = new_content
	self.kill = true
	self.handle_resize()


func set_max_font_size() -> void:
	var target = "a"
	var aux_size = 22
	var aux_font_size = self.get_metrics(aux_size)
	var char_size = self._calculate_size(target, aux_font_size)
	
	var av_size = self.layout.get_cell_size()
	
	var top = 200
	while char_size < av_size and top > 0:
		aux_size += 0.1 if av_size.x - char_size.x < 10 else 1.0
		char_size = self._calculate_size(target, aux_size)
		top -= 1
	self.max_font_size = aux_size 


func get_font_size() -> int:
	if self.max_font_size == 0:
		self.set_max_font_size()
	@warning_ignore('narrowing_conversion')
	return self.font_size * (self.max_font_size / 100)


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


func _calculate_size(c: String, font_size_p: int) -> Vector2:
	return self.font.get_string_size(
		c,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		font_size_p if font_size_p > 0 else 10
	)


func get_char_size(c: Char) -> Vector2:
	return self._calculate_size(c.value, self.get_font_size())


func get_metrics(s: float) -> int:
	@warning_ignore("narrowing_conversion")
	return self.font.get_ascent(s) - self.font.get_descent(s)
