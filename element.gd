@tool
extends Control

class_name Element

'''╭─[ Signals ]───────────────────────────────────────────────────────────────────────────╮'''
signal mouse_in
signal mouse_out
signal mouse_still
signal click_on
signal click_released_on
signal click_out
signal focus
signal un_focus
signal trigger
signal resize

'''╭─[ Variables ]─────────────────────────────────────────────────────────────────────────╮'''
var fields_handler: Fields
var input_handler: InputHandler
var animation_handler: AnimationHandler

'''╭─[ Export Variables ]──────────────────────────────────────────────────────────────────╮'''
@export var background: Color = Color.TRANSPARENT
@export var variable_fields: Dictionary = {}
@export var animations: Dictionary = {}

@export_group("Margin")
@export var margin_top: int = 0
@export var margin_right: int = 0
@export var margin_bottom: int = 0
@export var margin_left: int = 0

@export_group("Border")
@export var border_width: int = 1
@export var border_color: Color = Color.TRANSPARENT

@export_subgroup("Radius")
@export var border_radius: int = 0
@export var border_radius_a: int = 0 # Top left
@export var border_radius_b: int = 0 # Top right
@export var border_radius_c: int = 0 # Bottom right
@export var border_radius_d: int = 0 # Bottom left

'''╭─[ Lifecycle Functions ]───────────────────────────────────────────────────────────────╮'''
func _draw() -> void:
	# Draw bg.
	var bgr = StyleBoxFlat.new()
	bgr.bg_color = self.background
	
	if self.border_color != Color.TRANSPARENT:
		bgr.border_color = self.border_color
		bgr.set_border_width_all(self.border_width)
		bgr.border_blend = false
	
	if self.border_radius <= 0:
		bgr.corner_radius_top_left = self.border_radius_a
		bgr.corner_radius_top_right = self.border_radius_b
		bgr.corner_radius_bottom_right = self.border_radius_c
		bgr.corner_radius_bottom_left = self.border_radius_d
	else:
		bgr.set_corner_radius_all(self.border_radius)
	
	if self.border_radius:
		bgr.set_corner_radius_all(self.border_radius)
	
	draw_style_box(bgr, Rect2(Vector2.ZERO + Margin.start(self), self.get_real_size()))


func _notification(what: int) -> void:
	if what == NOTIFICATION_EDITOR_POST_SAVE and Engine.is_editor_hint():
		self.editor_settings()
		self.queue_redraw()


func _input(event: InputEvent) -> void:
	if !self.input_handler:
		self.input_handler = InputHandler.new(self)
	
	self.input_handler.handle_input(event)


func _ready() -> void:
	self.animation_handler = AnimationHandler.new(self)
	self.animation_handler.handle_connect()


func _init() -> void:
	self.fields_handler = Fields.new(self)
	self.animation_handler = AnimationHandler.new(self)


'''╭─[ Setters and Getters ]───────────────────────────────────────────────────────────────╮'''
func get_real_size() -> Vector2:
	return self.size - Margin.size(self)


func get_real_position() -> Vector2:
	return self.global_position + Margin.start(self)


func set_real_position(v: Vector2) -> void:
	self.global_position = v


func set_real_size(v: Vector2) -> void:
	self.size = v
	self.emit_signal('resize')


func get_variable_field(field: Fields.VariableFields) -> Variant:
	return self.variable_fields[Fields.get_key(field)]


func set_variable_field(field: Fields.VariableFields, key: String, new_value: Variant) -> void:
	self.variable_fields[Fields.get_key(field)][key] = new_value


func get_area() -> Rect2:
	return Rect2(self.get_real_position(), self.get_real_size())


func set_animations(d: Dictionary) -> void:
	self.animations = d


'''╭─[ To-Overwrite methods ]───────────────────────────────────────────────────────────────╮'''
## This function will be called every time the editor is saved.
func editor_settings() -> void:
	self.fields_handler = Fields.new(self)
	self.animation_handler = AnimationHandler.new(self)


## This function will be called by InputHandler if 
func emit(e: InputHandler.Evento) -> void:
	var signal_text = InputHandler.Evento.find_key(e).to_snake_case()
	self.emit_signal(signal_text)
