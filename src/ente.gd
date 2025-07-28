extends Control
class_name Ente

@warning_ignore("unused_signal")
signal resize
@warning_ignore("unused_signal")
signal on_ready
@warning_ignore("unused_signal")
signal on_click
@warning_ignore("unused_signal")
signal on_click_released
@warning_ignore("unused_signal")
signal on_focus
@warning_ignore("unused_signal")
signal on_unfocus
@warning_ignore("unused_signal")
signal mouse_in
@warning_ignore("unused_signal")
signal mouse_out
@warning_ignore("unused_signal")
signal mouse_still

enum Event {
	Resize,
	OnReady,
	OnClick,
	OnClickReleased,
	OnFocus,
	OnUnfocus,
	MouseIn,
	MouseOut,
	MouseStill,
}

@export_group("Background", "background")
@export var background_color: Color = Color.TRANSPARENT:
	set(value):
		background_color = value
		self.queue_redraw()
@export var background_border: Border:
	get():
		if !background_border:
			background_border = Border.new()
		return background_border
@export_group("", "")

var input_handler: InputHandler
var test_border: bool = false:
	set(value):
		test_border = value
		if value:
			background_border.width = 2
			background_border.color = Color.BLACK
		else:
			background_border.width = 0

func _ready() -> void:
	self.emit(Event.OnReady)
	self.input_handler = InputHandler.new(self)


func _draw() -> void:
	var bgr = StyleBoxFlat.new()
	bgr.bg_color = self.background_color
	
	# Sets border width.
	bgr.border_color = self.background_border.color
	bgr.border_blend = self.background_border.blend
	for key in ["top", "bottom", "left", "right"]:
		var magnitude = self.background_border["width_" + key] if self.background_border.width <= 0 else self.background_border.width
		bgr["border_width_" + key.to_snake_case()] = magnitude
	
	# Sets border radius.
	for key in ["top_left", "top_right", "bottom_right", "bottom_left"]:
		var full_key = "corner_radius_" + key.to_snake_case()
		bgr[full_key] = self.background_border[full_key] if self.background_border.radius <= 0 else self.background_border.radius
	
	draw_style_box(bgr, Rect2(Vector2.ZERO, self.size))


func _input(event: InputEvent) -> void:
	self.input_handler.handle_input(event)


''' ------------------------------------------------------------------------ '''


## [OVERWRITE] What to do at resize.
func handle_resize() -> void:
	self.queue_redraw()


## Set area and emits resize.
func set_area(r: Rect2) -> void:
	self.set_position(r.position)
	size = r.size
	self.handle_resize()
	self.emit(Event.Resize)


## Emits event-key signal.
func emit(e: Event) -> void:
	var event_key = self.get_event_key(e)
	self.emit_signal(event_key)


## Connects event.
func connect_event(e: Event, do_this: Callable) -> void:
	var event_key = self.get_event_key(e)
	self.connect(event_key, do_this)


## Gets event key..
func get_event_key(e: Event) -> String:
	return Event.find_key(e).to_snake_case()


## Returns ente area.
func get_area() -> Rect2:
	return Rect2(self.position, self.size)


## Remove child.
func remove_child_def(c: Node):
	if Engine.is_editor_hint():
		c.remove_child.call_deferred(c)
	else:
		c.remove_child(c)


## Add child.
func add_child_def(c: Node):
	if Engine.is_editor_hint():
		self.add_child.call_deferred(c)
	else:
		self.add_child(c)


## Clean old children and set the new ones.
func set_children(children: Array) -> void:
	for c in self.get_children():
		if c is Ente:
			c.queue_free()
	for c in children:
		self.add_child_def(c)
