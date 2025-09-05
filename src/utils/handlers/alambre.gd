@tool
extends Control
class_name Alambre

static var instance: Alambre

var input_emulator: LineEdit

func _ready() -> void:
	if !instance:
		instance = self
		self._set_input_emulator()
	else:
		self.queue_free()


static func _validate_action() -> bool:
	if !instance:
		push_error("Missing instance!") 
	return !!instance


static func call_input(component: InputComponent) -> void:
	if Alambre._validate_action():
		instance.input_emulator.grab_focus()
		instance.input_emulator.gui_input.connect(component.handle_gui_input)


static func end_input_call(component: InputComponent) -> void:
	if Alambre._validate_action():
		instance.input_emulator.release_focus()
		instance.input_emulator.gui_input.disconnect(component.handle_gui_input)


static func is_computer() -> bool:
	return !(OS.get_name() == "Android" or OS.get_name() == "iOS")


func _set_input_emulator() -> void:
	input_emulator = LineEdit.new()
	input_emulator.modulate.a = 0
	self.add_child(input_emulator)
