@tool
extends InputComponent
class_name TextInput

@export var line_color: Color = Color.BLACK
@export var placeholder: String = "Text"

const TEXT_NAME = "TextDisplay"
const LINE_NAME = "Line"

var text: Text
var line: Ente

## [OVERWRITE] Get Layout type.
func get_layout_type() -> Layout.LayoutType:
	return Layout.LayoutType.Sausage


## [OVERWRITE] Get chlidren.
func get_contenedor_children() -> Array:
	if !self.text:
		var t = Text.new()
		t.font_size = 100
		t.name = TEXT_NAME
		t.placement_axis_x = Placement.Middle
		t.placement_axis_y = Placement.Middle
		self.text = t
	if !self.line:
		var l = Ente.new()
		l.color = self.line_color
		l.name = LINE_NAME
		l.border = Border.new()
		l.border.corner_radius_bottom_right = 50
		l.border.corner_radius_bottom_left = 50
		self.line = l
	return [self.text, self.line]


## (Contenedor) [OVERWRITE]  Do it to pre-set some configurations.
func get_layout_config() -> Dictionary:
	var aux = super()
	aux[Sausage.VERTICAL] = true
	return aux


## [OVERWRITE] Modifies spaces before update.
func set_spaces() -> void:
	if !self.sub_spaces.is_empty():
		var t_space = self.sub_spaces[TEXT_NAME]
		t_space.fill = 90
		var l_space = self.sub_spaces[LINE_NAME]
		l_space.fill = 10

		l_space.margin = Margin.pancake()


## [OVERWRITE] Set all as default.
func clean() -> void:
	self.text = null
	self.line = null
	super()


func handle_on_focus():
	print("Focus!")


func get_text() -> Text:
	return self.get_ente_by_key(TEXT_NAME)
