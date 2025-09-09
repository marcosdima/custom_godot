@tool
extends Control
class_name Alambre

const EMPTY = "AA"
static var instance: Alambre

var input_emulator: EmulateInput
var curr_input_component: InputComponent

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


static func call_input(
	component: InputComponent,
	keyboard_type: DisplayServer.VirtualKeyboardType = DisplayServer.VirtualKeyboardType.KEYBOARD_TYPE_NUMBER
) -> void:
	if Alambre._validate_action():
		var input = instance.input_emulator
		instance.curr_input_component = component
		input.activate_with(component.get_value(), keyboard_type)


static func end_input_call() -> void:
	if Alambre._validate_action():
		instance.input_emulator.release_focus()
		instance.curr_input_component = null


static func is_computer() -> bool:
	return !(OS.get_name() == "Android" or OS.get_name() == "iOS")


func _handle_pass_gui_event(event: InputEvent) -> void:
	if curr_input_component:
		curr_input_component.handle_gui_input(event)


func _set_input_emulator() -> void:
	input_emulator = EmulateInput.new()
	input_emulator.modulate.a = 0
	input_emulator.gui_input.connect(_handle_pass_gui_event)
	self.add_child(input_emulator)
