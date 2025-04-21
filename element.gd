@tool
extends Control

class_name Element

'''╭─[ Export Variables ]──────────────────────────────────────────────────────────────────╮'''
@export var background: Color = Color.TRANSPARENT
@export var fields: Dictionary = {}
@export var variable_fields: Dictionary = {}

'''╭─[ Variables ]─────────────────────────────────────────────────────────────────────────╮'''
var fields_handler: Fields

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


'''╭─[ Setters and Getters ]───────────────────────────────────────────────────────────────╮'''
func get_real_size() -> Vector2:
	return self.size - Margin.size(self)


func get_real_position() -> Vector2:
	return self.global_position + Margin.start(self)


func set_real_position(v: Vector2) -> void:
	self.global_position = v


func set_real_size(v: Vector2) -> void:
	self.size = v


func get_variable_field(field: Fields.VariableFields):
	return self.variable_fields[Fields.get_key(field)]


func _set_fields():
	self.fields_handler = Fields.new(self)


'''╭─[ To-Overwrite methods ]───────────────────────────────────────────────────────────────╮'''
## This function will be called every time the editor is saved.
func editor_settings() -> void:
	self._set_fields()
