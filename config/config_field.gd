class_name ConfigField

## TODO: Missing validation. It's not mandatory, but can be util to prevent bugs in the future.

var value: String = ""
var type: String = ""

func _init(key: String, data: Dictionary) -> void:
	if !data.has("value") or !data.has("type"):
		push_error("[" + key + "] Missing value or type at ConfigField!")
		return
	
	self.value = str(data["value"])
	self.type = data["type"]

func parse_from():
	var v = self.value
	
	match self.type:
		"float": return float(v)
		"integer": return int(v)
		"bool": return v == 'true'
		_: return value
