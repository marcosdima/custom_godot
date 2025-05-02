extends Resource
class_name BaseAnimType

@export var settings: Dictionary = {}
var key = ""

func get_key() -> String:
	return self.key if self.key else "Nothing"


func set_key(s: String) -> void:
	self.key = s


func get_setting() -> Dictionary:
	return self.settings
