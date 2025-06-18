@tool
extends InputComponent
class_name TextInput

const PLACEHOLDER = "Placeholder"
const CONTENT = "Content"

@export var line_color: Color = Color.BLACK
@export var placeholder: String = "Text"
@export_group("Animations")
@export var on_appear: Animate
@export var on_disappear: Animate
@export var text_duration: float = 0.2
var text_delay: float:
	get():
		return text_delay / self.max_length

var aux_index = 0:
	set(value):
		if value < 0:
			aux_index = 0
		else:
			aux_index = value

func _ready() -> void:
	super()
	self.connect_event(Event.OnFocus, self.change_page_view)
	self.connect_event(Event.OnUnfocus, self.change_page_view)


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
				_: Printea.print_event(event)
		
		if remove_flag:
			aux_index -= 1
			text.set_char(self.aux_index, " ")
		elif !aux_set.is_empty() and self.validate_value(self.value + aux_set):
			text.set_char(self.aux_index, aux_set)
			self.aux_index += 1
		
		self.value = text.content.strip_edges()


## [OVERWRITTEN]
func get_component_children() -> Array:
	var placeh = Text.new()
	placeh.font_size = 100
	placeh.name = PLACEHOLDER
	placeh.placement_axis_x = Placement.Middle
	placeh.placement_axis_y = Placement.Middle
	placeh.content = self.placeholder
	
	var content = Text.new()
	content.font_size = 100
	content.name = CONTENT
	content.placement_axis_x = Placement.Middle
	content.placement_axis_y = Placement.Middle
	
	var aux = ""
	for i in range(self.max_lenght): aux += " "
	content.content = aux
	self.value = aux
	
	return [placeh, content]


## [OVERWRITTEN]
func modificate_space(key: String, space: Space) -> Space:
	space.order = 1 if key == CONTENT else 0
	return space


func get_text() -> Text:
	return self.get_ente_by_key(CONTENT)


func get_placeholder() -> Text:
	return self.get_ente_by_key(PLACEHOLDER)


func change_page_view() -> void:
	if self.aux_index == 0:
		for space in self.contenedor_spaces.values():
			var curr = space.order
			space.order = 1 if curr == 0 else 0
		
		# This call update page order.
		Layout.refresh_spaces(self)
