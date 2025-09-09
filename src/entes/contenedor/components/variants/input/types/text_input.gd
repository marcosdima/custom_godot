@tool
extends InputComponent
class_name TextInput

const PLACEHOLDER_ORDER = 0
const CONTENT_ORDER = 1

const PLACEHOLDER = "Placeholder"
const CONTENT = "Content"

@export var placeholder_content: String = ""
@export var text: TextResourse:
	get():
		if !text:
			text = TextResourse.new()
		text.min_chars = max_length
		return text

var placeholder: Text
var content: Text
var line_text: LineEdit

## [OVERWRITTEN] From: Ente
func initialization_routine() -> void:
	set_follow_resize = true
	super()


## [OVERWRITTEN] From: Component
func get_children_to_set() -> Array:
	content = self.get_text(CONTENT, value)
	
	var aux = [content]
	if placeholder_content.is_empty():
		placeholder = null
	else:
		placeholder = self.get_text(PLACEHOLDER, placeholder_content)
		aux.append(placeholder)
	
	return aux


## [OVERWRITTEN] From: Component
func get_layout_spaces() -> Dictionary:
	for space: Space in layout.spaces.values():
		space.order = PLACEHOLDER_ORDER if space.name == PLACEHOLDER else CONTENT_ORDER
	return layout.spaces


## [OVERWRITTEN] from InputComponent
func clear_input() -> void:
	content.content = ""
	content.refresh()
	super()
	self.change_page_view(false)


## [OVERWRITTEN] from InputComponent
func handle_on_focus() -> void:
	super()
	self.change_page_view(true)


## [OVERWRITTEN] from InputComponent
func handle_on_unfocus() -> void:
	super()
	self.change_page_view(false)


## [OVERWRITTEN] from InputComponent
func set_value(v) -> void:
	super(v)
	self.update_content()


## [OVERWRITE] Called when new value was setted successfully-
func update_content() -> void:
	if content:
		content.update_text(value)
		self.handle_resize()


func change_page_view(focus: bool) -> void:
	var ly = layout as Pages
	
	if focus or !placeholder:
		ly.on_page = CONTENT_ORDER
	elif content.content.is_empty():
		ly.on_page = PLACEHOLDER_ORDER
	
	layout.calculate_dimensions()


func get_text(t_name: String, t_content: String, new_text = Text.new()) -> Text:
	new_text.set_from_resource(text)
	new_text.name = t_name
	new_text.color = color
	new_text.content = t_content
	return new_text
