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
@export_subgroup("Placement", "")
@export var horizontal: Contenedor.Placement = Contenedor.Placement.Middle
@export var vertical: Contenedor.Placement = Contenedor.Placement.Middle
@export_group("", "")


var placeholder: Text:
	get():
		return contenedor.get_ente_by_key(PLACEHOLDER)
var content: Text:
	get():
		return contenedor.get_ente_by_key(CONTENT)

func handle_resize() -> void:
	super()


func _ready() -> void:
	super()
	self.connect_event(Event.OnFocus, self.change_page_view)
	self.connect_event(Event.OnUnfocus, self.change_page_view)

## [OVERWRITTEN] From: Component
func get_children_to_set() -> Array:
	var set_text = func(name: String, content: String):
		var t = Text.new()
		t.content = content
		t.name = name
		t.font_size = font_size
		t.color = color
		t.placement_axis_x = horizontal
		t.placement_axis_y = vertical
	
	var placeholder_aux = set_text.call(PLACEHOLDER, placeholder_content)
	var content_aux = set_text.call(CONTENT, "")
	
	return [placeholder_aux, content_aux]


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


func change_page_view() -> void:
	var ly = contenedor.layout as Pages
	ly.on_page 

 
