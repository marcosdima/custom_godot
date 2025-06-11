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

@export var refresh: bool:
	set(value):
		Breader.set_as_default(self)
		refresh = false
@export_group("Background")
@export var color: Color = Color.TRANSPARENT
@export var border: Border = Border.new()

@export_group("Test", "test_")
@export var test_border: bool = false
@export_group("")
@export var animations: Dictionary = {}

func _ready() -> void:
	super()
	Animator.connect_animator(self)
	if self is Contenedor:
		ContenedorAnimator.connect_contenedor_animator(self)
	self.emit(Event.OnReady)


func _draw() -> void:
	var bgr = StyleBoxFlat.new()
	bgr.bg_color = self.color
	
	if self.test_border:
		self.border.width = 2
		self.border.color = Color.BLACK
	
	# Sets border width.
	bgr.border_color = self.border.color
	bgr.border_blend = self.border.blend
	for key in ["top", "bottom", "left", "right"]:
		var magnitude = self.border["width_" + key] if self.border.width <= 0 else self.border.width
		bgr["border_width_" + key.to_snake_case()] = magnitude
	
	# Sets border radius.
	for key in ["top_left", "top_right", "bottom_right", "bottom_left"]:
		var full_key = "corner_radius_" + key.to_snake_case()
		bgr[full_key] = self.border[full_key] if self.border.radius <= 0 else self.border.radius
	
	draw_style_box(bgr, Rect2(Vector2.ZERO, self.size))


func _init() -> void:
	super()
	Breader.set_as_default(self)

''' ------------------------------------------------------------------------ '''


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


## Set area and emits resize.
func set_area(r: Rect2) -> void:
	self.global_position = r.position
	if r.size != self.size:
		self.size = r.size
		self.emit(Event.Resize)


## Returns ente area.
func get_area() -> Rect2:
	return Rect2(self.global_position, self.size)
