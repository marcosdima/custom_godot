@tool
extends InputComponent
class_name TextInput

const PLACEHOLDER_ORDER = 0
const CONTENT_ORDER = 1

const PLACEHOLDER = "Placeholder"
const CONTENT = "Content"

@export_group("Text", "")
@export var placeholder_content: String = "Text"
@export var font_size: int = 100
@export var font_proportional_size: int = 0
@export var min_chars: int = 0
@export_subgroup("Placement", "") ## TODO: Implement at component.
@export var horizontal: Contenedor.Placement = Contenedor.Placement.Middle
@export var vertical: Contenedor.Placement = Contenedor.Placement.End
@export_group("", "")

var placeholder: Text
var content: Text

func _ready() -> void:
	super()
	self.connect_event(Event.OnFocus, self.change_page_view.bind(true))
	self.connect_event(Event.OnUnfocus, self.change_page_view.bind(false))


## [OVERWRITTEN] From: Component
func get_children_to_set() -> Array:
	if !placeholder or !content:
		placeholder = self.get_text(PLACEHOLDER, placeholder_content)
		content = self.get_text(CONTENT, value)
	return [placeholder, content]


## [OVERWRITTEN] From: Component
func get_layout_spaces() -> Dictionary:
	for space: Space in layout.spaces.values():
		space.order = PLACEHOLDER_ORDER if space.name == PLACEHOLDER else CONTENT_ORDER
	return layout.spaces


## [OVERWRITTEN] from InputComponent
func handle_key(key: String) -> void:
	content.add_char(key)
	value = content.content


## [OVERWRITE] What to do at some action.
func handle_some_action(action: InputData.Action, pressed: bool) -> void:
	match action:
		InputData.Action.Remove:
			if !pressed:
				content.remove_last_char()
				value = content.content
				self.handle_resize()
		_: pass


## [OVERWRITTEN] from InputComponent
func clear_input() -> void:
	content.content = ""
	content.refresh()
	super()
	self.change_page_view(false)


func change_page_view(focus: bool) -> void:
	var ly = layout as Pages
	
	if focus:
		ly.on_page = CONTENT_ORDER
	elif content.content.is_empty():
		ly.on_page = PLACEHOLDER_ORDER
	
	layout.calculate_dimensions()


func get_text(t_name: String, t_content: String) -> Text:
	var text = Text.new()
	text.content = t_content
	text.name = t_name
	text.font_size = font_size
	text.font_proportional_size = font_proportional_size
	text.color = color
	text.min_content_lenght = min_chars
	text.placement_axis_x = horizontal
	text.placement_axis_y = vertical
	return text
