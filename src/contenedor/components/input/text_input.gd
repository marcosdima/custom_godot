@tool
extends InputComponent
class_name TextInput

@export var line_color: Color = Color.BLACK
@export var placeholder: String = "Text":
	set(value):
		if value != placeholder:
			placeholder = value
			var placeh = self.get_placeholder()
			placeh.content = value
			Breader.set_as_default(placeh)
@export var max_length: int = 10
@export_group("Animations")
@export var text_duration: float = 0.2
var text_delay: float:
	get():
		return text_delay / self.get_text_legnth()

const PLACEHOLDER = "Placeholder"
const CONTENT = "Content"

func _init() -> void:
	super()
	self.set_animations()


func _input(event: InputEvent) -> void:
	super(event)
	var handler = self.input_handler
	
	if event is InputEventKey and event.is_pressed() and handler.focus:
		var key = handler.data[InputHandler.KEY]
		var text = self.get_placeholder()
		text.content += key
		Breader.set_as_default(text)


func set_animations() -> void:
	var pholder = self.get_placeholder()
	
	## Go up.
	var go_up = AnimateContenedor.new()
	var slide_up = Slide.new()
	slide_up.duration = self.text_duration
	slide_up.direction = Slide.Direction.Down
	go_up.animate_wrapper.animate = slide_up
	go_up.delay = self.text_delay
	
	## Dissapear.
	var dis_wrapper = AnimateWrapper.new()
	var dissapear = Prop.new()
	dis_wrapper.animate = dissapear
	dissapear.duration = ((self.text_delay + self.text_duration) * self.get_text_legnth()) * 0.2
	
	var focus_key = self.get_event_key(Event.OnFocus)
	pholder.contenedor_animations[focus_key] = go_up
	pholder.animations[focus_key] = dis_wrapper
	
	# Goes to normal with unfocus
	var appear_wrapper = AnimateWrapper.new()
	var appear = Prop.new()
	appear.start_value = 0
	appear.end_value = 1
	appear.duration = self.text_delay
	appear_wrapper.animate = appear
	
	var go_down = AnimateContenedor.new()
	var slide_down = Slide.new()
	go_down.delay = self.text_delay
	slide_down.duration = self.text_duration
	slide_up.direction = Slide.Direction.Down
	go_down.animate_wrapper.animate = slide_down
	
	var unfocus_key = self.get_event_key(Ente.Event.OnUnfocus)
	pholder.contenedor_animations[unfocus_key] = go_down
	pholder.animations[unfocus_key] = appear_wrapper


## [OVERWRITE] Get chlidren.
func get_contenedor_children() -> Array:
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
	for i in range(self.max_length): aux += " "
	content.content = aux
	
	return [placeh, content]


## [OVERWRITE] Modifies spaces before update.
func set_space(space_key: String) -> void:
	self.spaces[space_key].order = 1 if space_key == CONTENT else 2


func get_text() -> Text:
	return self.get_ente_by_key(CONTENT)


func get_placeholder() -> Text:
	return self.get_ente_by_key(PLACEHOLDER)


func get_text_legnth() -> int:
	var t = self.get_text()
	if t:
		return self.get_text().content.length()
	else:
		return 0
