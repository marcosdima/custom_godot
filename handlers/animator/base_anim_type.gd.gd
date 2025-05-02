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


static func set_as_animation_type(do: AnimationHandler.Do) -> AnimationType:
	var handler = AnimationType.new()
	handler.set_key(AnimationHandler.Do.find_key(do))
	return handler
