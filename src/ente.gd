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

@export var immune_system: ImmuneSystem = ImmuneSystem.new()
@export var margin: Margin = Margin.new()
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
@export_group("Test", "test_")
@export var test_border: bool = false:
	set(value):
		test_border = value
		if value:
			background_border.width = 2
			background_border.color = Color.BLACK
		else:
			background_border.width = 0
@export_group("", "")

var input_handler: InputHandler:
	get():
		if !input_handler:
			input_handler = InputHandler.new(self)
		return input_handler
var on_editor: bool:
	get():
		return Engine.is_editor_hint()
var _initialized: bool = false

func _init() -> void:
	pass


func _ready() -> void:
	if !on_editor:
		immune_system.init(self)
	self.initialization_routine()
	self.emit(Event.OnReady)


func _draw() -> void:
	var bgr = StyleBoxFlat.new()
	bgr.bg_color = background_color
	
	# Sets border width.
	bgr.border_color = background_border.color
	bgr.border_blend = background_border.blend
	for key in ["top", "bottom", "left", "right"]:
		var magnitude = self.background_border["width_" + key] if self.background_border.width <= 0 else self.background_border.width
		bgr["border_width_" + key.to_snake_case()] = magnitude
	
	# Sets border radius.
	for key in ["top_left", "top_right", "bottom_right", "bottom_left"]:
		var full_key = "corner_radius_" + key.to_snake_case()
		bgr[full_key] = self.background_border[full_key] if self.background_border.radius <= 0 else self.background_border.radius
	
	draw_style_box(bgr, Rect2(Vector2.ZERO, size))


func _input(event: InputEvent) -> void:
	input_handler.handle_input(event)


''' ------------------------------------------------------------------------ '''


## [OVERWRITE] What to do to initilizate.
func initialization_routine() -> void:
	_initialized = true
	self.handle_resize()


## [OVERWRITE] What to do at resize.
func handle_resize() -> void:
	self.queue_redraw()


## Returns ente area.
func get_area() -> Rect2:
	return Rect2(position, size)


## Set area and emits resize.
func set_area(r: Rect2) -> void:
	if r.is_equal_approx(get_area()) and !on_editor:
		return
	self.set_position(r.position)
	size = r.size
	self.handle_resize()
	self.emit(Event.Resize)


## Set 'visible' as value.
func change_visible(value: bool) -> void:
	visible = value


## Emits event-key signal.
func emit(e: Event) -> void:
	var event_key: String = Event.find_key(e).to_snake_case()
	self.emit_signal(event_key)


## Connects event.
func connect_event(e: Event, do_this: Callable) -> void:
	var event_key = Event.find_key(e).to_snake_case()
	self.connect(event_key, do_this)
