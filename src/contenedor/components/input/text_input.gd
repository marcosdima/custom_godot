@tool
extends InputComponent
class_name TextInput

@export var line_color: Color = Color.BLACK
@export var placeholder: String = "Text"

const TEXT_NAME = "TextDisplay"
const LINE_NAME = "Line"

var text: Text

func initialization_routine() -> void:
	self.value = self.placeholder
	super()


## [OVERWRITE] Get Layout type.
func get_layout_type() -> Layout.LayoutType:
	return Layout.LayoutType.Sausage


## [OVERWRITE] Get chlidren.
func get_contenedor_children() -> Array:
	var t = Text.new()
	t.font_size = 100
	t.name = TEXT_NAME
	self.text = t
	
	var l = Ente.new()
	l.color = self.line_color
	l.name = LINE_NAME
	
	return [t, l]


## (Contenedor) [OVERWRITE]  Do it to pre-set some configurations.
func get_layout_config() -> Dictionary:
	var aux = super()
	aux[Sausage.VERTICAL] = true
	return aux


## [OVERWRITE] Modifies spaces before update.
func set_spaces() -> void:
	var text_space = self.sub_spaces[TEXT_NAME] as SausageSpace
	text_space.fill = 90
	text_space.order = 0
	
	var line_space = self.sub_spaces[LINE_NAME] as SausageSpace
	line_space.fill = 10
	line_space.order = 1
	
	if self.text.content != self.value:
		self.text.content = self.value


func handle_on_focus():
	print("Focus!")


func get_text() -> Text:
	return self.get_ente_by_key(TEXT_NAME)
