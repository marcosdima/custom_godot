class_name InputData

enum Action {
	Unknown,
	Remove,
	Delete,
	Space,
}

const KEY = "key"
const ACTION = "action"

var is_numeric: bool
var is_letter: bool
var is_sign: bool
var values: Dictionary


func set_key(val: String) -> void:
	self.values[KEY] = val


func set_action(input: String) -> void:
	var aux_action = Action.Unknown
	match input:
		"Backspace": aux_action = Action.Remove
		"Space": aux_action = Action.Space
	self.values[ACTION] = aux_action
