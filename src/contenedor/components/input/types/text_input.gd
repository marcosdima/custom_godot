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
@export var vertical: Contenedor.Placement = Contenedor.Placement.Middle
@export_group("", "")

var placeholder: Text:
	get():
		if !placeholder:
			placeholder = get_text(PLACEHOLDER, placeholder_content)
		return placeholder
var content: Text:
	get():
		if !content:
			content = get_text(CONTENT, "")
		return content

func _ready() -> void:
	super()
	self.connect_event(Event.OnFocus, self.change_page_view.bind(true))
	self.connect_event(Event.OnUnfocus, self.change_page_view.bind(false))


## [OVERWRITTEN] From: Ente
func handle_resize() -> void:
	super()
	print(contenedor.entes)


## [OVERWRITTEN] From: Component
func get_children_to_set() -> Array:
	return [placeholder, content]


## [OVERWRITTEN] From: Component
func get_layout_spaces() -> Dictionary:
	var cont = contenedor.layout.spaces.get(CONTENT)
	var phold = contenedor.layout.spaces.get(PLACEHOLDER)
	
	phold.order = PLACEHOLDER_ORDER
	cont.order = CONTENT_ORDER
	
	return {
		CONTENT: cont,
		PLACEHOLDER: phold,
	}


## [OVERWRITTEN] from InputComponent
func clear_input() -> void:
	super()
	content.content = ""


func change_page_view(focus: bool) -> void:
	var ly = contenedor.layout as Pages
	
	if focus:
		ly.on_page = CONTENT_ORDER
	elif content.content.is_empty() and focus:
		ly.on_page = PLACEHOLDER_ORDER


func get_text(t_name: String, t_content: String) -> Text:
	var t = Text.new()
	t.content = t_content
	t.name = t_name
	t.font_size = font_size
	t.color = color
	t.placement_axis_x = horizontal
	t.placement_axis_y = vertical
	return t
	
