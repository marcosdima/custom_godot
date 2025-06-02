@tool
extends Component
class_name Text

@export_multiline var content: String = "Text"
@export_group("Font", "font_")
@export var font: FontFile
@export var font_color: Color = Color.BLACK
@export var font_size: int = 16

var flag_writted: bool = false
var enter = '\n'
var max_font_size: float = 0

func set_children() -> void:
	self.set_content()


func set_layout() -> void:
	self.layout_type = Layout.LayoutType.Grid
	super()
	
	# Count lines.
	var columns_aux = 1
	var row_counter = 1
	var columns_counter = 0
	for c in self.content:
		if c == enter:
			row_counter += 1
			if columns_aux > columns_counter:
				columns_counter = columns_aux
			columns_aux = 1
		else:
			columns_aux += 1
	if columns_aux > columns_counter:
		columns_counter = columns_aux
	
	## Set contenedor config.
	self.config[Grid.ROWS] = row_counter
	self.config[Grid.COLUMNS] = columns_counter - 1
	
	for c in self.get_children():
		var e = c as Char
		var space = self.sub_spaces[c.name] as GridSpace
		
		if space.column_span == 1 and space.row_span == 1:
			var char_size = self.get_char_size(c.value, self.get_font_size())
			var ente_size = e.size
			var c_span = char_size.x / ente_size.x
			var r_span = char_size.y / ente_size.y
			
			space.column_span = c_span
			space.row_span = r_span
		
		space.row = int(e.name.substr(0, 1))
	
	self.layout.update_spaces()


func set_content() -> void:
	var char_count = 0
	var aux_line = 0
	for c in self.content:
		if c != enter:
			var ch = Char.new()
			ch.name = str(aux_line) + str(char_count)
			ch.line = aux_line
			ch.value = c
			self.add_child_def(ch)
		else:
			aux_line += 1
			char_count = 0
		char_count += 1


func get_font_size() -> float:
	var grid = self.layout as Grid
	var metrics = self.font.get_ascent(self.font_size) - self.font.get_descent(self.font_size)
	self.max_font_size = 0
	if !self.max_font_size:
		var target = 'a'
		var aux_size = 1
		var char_size = self.get_char_size(target, aux_size)
		var av_size = self.layout.get_cell_size()
		
		var top = 200
		while char_size < av_size and top > 0:
			aux_size += 0.1 if av_size.x - char_size.x < 50 else 1
			char_size = self.get_char_size(target, max_font_size)
			top -= 1
		self.max_font_size = aux_size
	return self.font_size * (self.max_font_size / 100)


func get_char_size(c: String, font_size: float) -> Vector2:
	return self.font.get_string_size(
		c,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		font_size
	)
