@tool
extends InputComponent
class_name TextInput

var min_chars: int = !0

const PLACEHOLDER: String = "PLACEHOLDER"
const CONTENT: String = "CONTENT"

@export var placeholder: String = "Text"
var placeholder_flag: bool
var text_duration: float = 0.2
var text_delay: float:
	get():
		return text_delay / self.max_length

func _ready() -> void:
	super()
	change_to_placeholder(true)
	self.connect_event(Event.OnFocus, func(): change_to_placeholder())
	self.connect_event(Event.OnUnfocus, func(): change_to_placeholder(self.value.is_empty()))


## [OVERWRITTEN] From: Contenedor -> Ente
func handle_resize() -> void:
	super()
	if placeholder_flag == null:
		change_to_placeholder(true)


## [OVERWRITTEN] From: Component.
func get_component_children() -> Array:
	var content = Text.new()
	content.font_size = 100
	content.color = self.color
	content.min_chars = self.min_chars
	content.name = CONTENT
	content.content = self.value if !self.placeholder_flag else self.placeholder
	content.placement_axis_x = Placement.Middle
	content.placement_axis_y = Placement.Middle
	return [content]


## [OVERWRITTEN] From: InputComponent
func clear_input() -> void:
	placeholder_flag = true
	super()


func handle_key_event(event: InputEventKey) -> void:
	super(event)
	var handler = self.input_handler
	
	if handler.focus and event.pressed:
		var data = handler.data
		var aux_set = ""
		var remove_flag = false
		
		if data.is_letter or data.is_numeric or data.is_sign: aux_set = data.values[InputData.KEY]
		else:
			var action = data.values[InputData.ACTION] as InputData.Action
			match action:
				InputData.Action.Remove: remove_flag = true
				InputData.Action.Space: aux_set = " "
				_: Printea.print_event(event)
		
		var curr_content = self.value
		if remove_flag:
			if curr_content.length() > 2:
				curr_content = curr_content.erase(curr_content.length() - 2)
			else:
				curr_content = ""
		elif !aux_set.is_empty() and self.validate_value(aux_set):
			curr_content += aux_set
		
		if self.value != curr_content:
			self.set_value(curr_content)
			self.change_to_placeholder()


func change_to_placeholder(flag: bool = false) -> void:
	placeholder_flag = flag
	self.remove_all()
	self.handle_resize()
