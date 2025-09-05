@tool
extends Component
class_name Text

## TODO: Upper case letters with accent can interfere with below-baseline letters.

const ENTER = '\n'

@export_multiline var content: String = "Text":
	set(value):
		content = value
		if on_editor:
			self.refresh()
@export var min_content_lenght: int = 0
@export_group("Font", "font_")
@export var font: FontFile = load("res://static/fonts/CaviarDreams.ttf")
@export var font_size: int = 16
@export var font_proportional_size: int = 0

static func create(
	name_: String,
	content_: String,
	proportional: int = 60,
	horizontal: Placement = Placement.Middle,
	vertical: Placement = Placement.Middle,
) -> Text:
	var text = Text.new()
	text.name = name_
	text.content = content_
	text.font_proportional_size = proportional
	text.placement_axis_x = horizontal
	text.placement_axis_y = vertical
	return text

## [OVERWRITTEN] From: Ente
func initialization_routine() -> void:
	super()
	children_handler.follow_resize = true


## [OVERWRITTEN] From: Contenedor
func get_layout_type() -> Layout.LayoutType:
	return Layout.LayoutType.Grid


## [OVERWRITTEN] From: Contenedor
func get_children_to_set() -> Array:
	var aux_children = []
	var text_config = self.parse_text_to_config() 
	var i = 0
	
	for r in range(text_config.size()):
		var len_r = text_config[r]
		for c in range(len_r):
			var char_aux = Char.new(self, content[i], r, c, i)
			aux_children.append(char_aux)
			i += 1
		i += 1
	
	return aux_children


## [OVERWRITTEN] From: Component
func get_layout_spaces() -> Dictionary:
	var spaces = layout.spaces
	
	for key in spaces:
		var c: Char = self.get_ente_by_key(key)
		var space = spaces.get(key) as GridSpace
		
		var char_size = c.get_char_size()
		var ente_size = layout.get_cell_size()
		
		space.column = c.column
		space.row = c.row
		
		var unit_x = char_size.x / ente_size.x
		space.column_span = unit_x
		var unit_y = char_size.y / ente_size.y 
		space.row_span = unit_y
	
	return spaces


## [OVERWRITTEN] From: Component
func get_layout_config() -> Dictionary:
	var config = self.parse_text_to_config()
	var max = config.values().max()
	return {
		Grid.COLUMNS: max if max > min_content_lenght else min_content_lenght,
		Grid.ROWS: config.size()
	}


## Returns a dictionary with the size of each content line.
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


func get_font_size() -> int:
	if font_proportional_size > 0 and font_proportional_size <= 100:
		var t_size = size * (font_proportional_size / 100.0)
		var aux = 16
		
		var aux_char = Char.new(self, ".", 0, 0, 0)
		var result_size = aux_char.get_char_size(aux)
		
		while result_size.x < t_size.x and result_size.y < t_size.y and aux < 1000:
			aux += 1
			result_size = aux_char.get_char_size(aux)
		
		return aux - 1
	else:
		return font_size


func update_content(new_content: String) -> void:
	content = new_content
	self.refresh()


func add_char(char_: String) -> void:
	self.update_content(content + char_)


func remove_last_char() -> void:
	if content.length() > 0:
		self.update_content(content.erase(content.length() - 1))
