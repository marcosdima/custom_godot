extends Control
class_name Ente

enum Event {
	Resize,
	OnReady,
}

@warning_ignore("unused_signal")
signal resize
@warning_ignore("unused_signal")
signal on_ready

@export_group("Background")
@export var color: Color = Color.TRANSPARENT
@export var border: Border

@export_group("")
@export var animations: Dictionary = {}

func _ready() -> void:
	if !Engine.is_editor_hint():
		Animator.connect_animator(self)
		self.emit(Event.OnReady)


func _notification(what: int) -> void:
	## Remainder: This will be called with @tool scripts only.
	if what == self.NOTIFICATION_EDITOR_POST_SAVE:
		self.editor_settings()


func _draw() -> void:
	var bgr = StyleBoxFlat.new()
	bgr.bg_color = self.color
	
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


func set_area(r: Rect2) -> void:
	self.global_position = r.position
	self.size = r.size
	self.queue_redraw()
	self.emit(Event.Resize)


## Returns ente area.
func get_area() -> Rect2:
	return Rect2(self.global_position, self.size)


## Emits event-key signal.
func emit(e: Event) -> void:
	var event_key = self.get_event_key(e)
	self.emit_signal(event_key)


func connect_event(e: Event, do_this: Callable) -> void:
	var event_key = self.get_event_key(e)
	self.connect(event_key, do_this)


func get_event_key(e: Event) -> String:
	return Event.find_key(e).to_snake_case()


func editor_settings() -> void:
	if !self.border:
		self.border = Border.new()
	Animator.set_animations(self)
	self.queue_redraw()
