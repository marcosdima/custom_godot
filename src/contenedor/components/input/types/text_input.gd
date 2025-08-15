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
		placeholder = get_text(PLACEHOLDER, placeholder_content)
		content = get_text(CONTENT, value)
	return [placeholder, content]


## [OVERWRITTEN] From: Component
func get_layout_spaces() -> Dictionary:
	var cont = layout.spaces.get(CONTENT)
	var phold = layout.spaces.get(PLACEHOLDER)
	
	phold.order = PLACEHOLDER_ORDER
	cont.order = CONTENT_ORDER
	
	return {
		CONTENT: cont,
		PLACEHOLDER: phold,
	}


## [OVERWRITTEN] from InputComponent
func handle_key(key: String) -> void:
	content.add_char(key)
	value = content.content
	self.handle_resize() ## (Hotfix) TODO: Text does not update right without this.


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
	super()
	content.content = ""


func change_page_view(focus: bool) -> void:
	var ly = layout as Pages
	
	if focus:
		ly.on_page = CONTENT_ORDER
	elif content.content.is_empty():
		ly.on_page = PLACEHOLDER_ORDER
	
	layout.calculate_dimensions()


func get_text(t_name: String, t_content: String) -> Text:
	var t = Text.new()
	t.content = t_content
	t.name = t_name
	t.font_size = font_size
	t.color = color
	t.placement_axis_x = horizontal
	t.placement_axis_y = vertical
	return t
