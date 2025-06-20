extends Ancestor
class_name Ente

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
@export var background_color: Color = Color.TRANSPARENT ## TODO: Rename background_color
@export var background_border: Border = Border.new()
@export_group("")
@export var animations: Dictionary = {}

static var test_border: bool = false

func _ready() -> void:
	super()
	Animator.connect_animator(self)
	if self is Contenedor:
		ContenedorAnimator.connect_contenedor_animator(self)
	self.emit(Event.OnReady)


func _draw() -> void:
	var bgr = StyleBoxFlat.new()
	bgr.bg_color = self.background_color
	
	if Ente.test_border:
		self.background_border.width = 2
		self.background_border.color = Color.BLACK
	else:
		self.background_border.width = 0
		self.background_border.color = Color.TRANSPARENT
	
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


''' ------------------------------------------------------------------------ '''


## [OVERWRITE] What to do at resize.
func handle_resize() -> void:
	Animator.set_animations(self)
	self.queue_redraw()


## Set area and emits resize.
func set_area(r: Rect2) -> void:
	self.global_position = r.position
	self.size = r.size
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
	return Rect2(self.global_position, self.size)
