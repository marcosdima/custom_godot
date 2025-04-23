@tool
extends Control

class_name Element

'''╭─[ Export Variables ]──────────────────────────────────────────────────────────────────╮'''
@export var background: Color = Color.TRANSPARENT
@export var variable_fields: Dictionary = {}

@export_group("Margin")
@export var margin_top: int = 0
@export var margin_right: int = 0
@export var margin_bottom: int = 0
@export var margin_left: int = 0

@export_group("Border")
@export var border_color: Color = Color.WHITE
@export var border_width: int = 1

'''╭─[ Variables ]─────────────────────────────────────────────────────────────────────────╮'''
var fields_handler: Fields
var input_handler: InputHandler

'''╭─[ Lifecycle Functions ]───────────────────────────────────────────────────────────────╮'''
func _draw() -> void:
	# Draw background.
	var rect = Rect2(Margin.start(self), self.get_real_size()) 
	self.draw_rect(rect, self.background, true)


# To see changes in the editor.
func _notification(what: int) -> void:
	if what == NOTIFICATION_EDITOR_POST_SAVE and Engine.is_editor_hint():
		self.editor_settings()
		self.queue_redraw()


func _input(event: InputEvent) -> void:
	if !self.input_handler:
		self.input_handler = InputHandler.new(self)
	self.input_handler.handle_input(event)


'''╭─[ Setters and Getters ]───────────────────────────────────────────────────────────────╮'''
func get_real_size() -> Vector2:
	return self.size - Margin.size(self)


func get_real_position() -> Vector2:
	return self.global_position + Margin.start(self)


func set_real_position(v: Vector2) -> void:
	self.global_position = v


func set_real_size(v: Vector2) -> void:
	self.size = v


func get_variable_field(field: Fields.VariableFields) -> Variant:
	return self.variable_fields[Fields.get_key(field)]


func _set_fields() -> void:
	self.fields_handler = Fields.new(self)


func get_area() -> Rect2:
	return Rect2(self.get_real_position(), self.get_real_size())


'''╭─[ To-Overwrite methods ]───────────────────────────────────────────────────────────────╮'''
## This function will be called every time the editor is saved.
func editor_settings() -> void:
	self._set_fields()


## This function will be called by InputHandler if 
func emit(_e: InputHandler.Evento) -> void:
	pass
