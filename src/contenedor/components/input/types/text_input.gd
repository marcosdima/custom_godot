@tool
extends InputComponent
class_name TextInput

const PLACEHOLDER = "Placeholder"
const CONTENT = "Content"

var placeholder_color: Color = Color.BLACK
var content_color: Color = Color.BLACK

@export_group("Text", "")
@export var placeholder: String = "Text"
@export var font_size: int = 100:
	set(value):
		if Engine.is_editor_hint():
			get_text().font_size = value
			get_placeholder().font_size = value
		font_size = value
@export_group("", "")

var view_flag = false

func handle_resize() -> void:
	super()


func _ready() -> void:
	super()
	self.connect_event(Event.OnFocus, self.change_page_view)
	self.connect_event(Event.OnUnfocus, self.change_page_view)

## [OVERWRITTEN] From: Component
func get_children_to_set() -> Array:
	var placeh = Text.new()
	placeh.font_size = 100
	placeh.color = self.color
	placeh.name = PLACEHOLDER
	placeh.content = self.placeholder
	
	var content = Text.new()
	content.font_size = 100
	content.color = self.color
	content.name = CONTENT
	content.content = ""
	
	value = ""
	
	return [placeh, content]


## [OVERWRITTEN] From: Component
func get_layout_spaces() -> Dictionary:
	var cont = contenedor.layout.spaces.get(CONTENT)
	var phold = contenedor.layout.spaces.get(PLACEHOLDER)
	
	phold.order = 0 if !view_flag else 1
	cont.order = 1 if !view_flag else 0
	
	return {
		CONTENT: cont,
		PLACEHOLDER: phold,
	}


## [OVERWRITTEN] from InputComponent
func clear_input() -> void:
	super()
	var content = self.get_text()
	content.content = ""


func get_text() -> Text:
	return contenedor.get_ente_by_key(CONTENT)


func get_placeholder() -> Text:
	return contenedor.get_ente_by_key(PLACEHOLDER)


func change_page_view() -> void:
	view_flag = !view_flag
	self.handle_resize()


'''
func handle_key_event(event: InputEventKey) -> void:
	super(event)
	var handler = self.input_handler
	
	if handler.focus and event.pressed:
		var data = handler.data
		var text = self.get_text()
		var aux_set = ""
		var remove_flag = false
		
		if data.is_letter or data.is_numeric or data.is_sign: aux_set = data.values[InputData.KEY]
		else:
			var action = data.values[InputData.ACTION] as InputData.Action
			match action:
				InputData.Action.Remove: remove_flag = true
				InputData.Action.Space: aux_set = " "
				_: print(event)
		
		if remove_flag:
			aux_index -= 1
			text.set_char(aux_index, "")
		elif !aux_set.is_empty() and self.validate_value(value + aux_set):
			text.set_char(aux_index, aux_set)
			self.aux_index += 1
		
		self.set_value(text.content.strip_edges())
'''
