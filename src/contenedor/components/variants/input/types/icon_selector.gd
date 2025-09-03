@tool
extends InputComponent
class_name IconSelector

signal on_next

var curr: Icon
var icons: Array = []

func _init() -> void:
	icons = Icon.DefaultIcons.values().filter(Icon.exists)
	value = str(icons.front())
	self.connect_event(Event.OnClickReleased, next)


## [OVERWRITTEN] From: Component
func get_children_to_set() -> Array:
	curr = Icon.new(int(value))
	curr.color = color
	return [curr]


func next() -> void:
	var i = icons.find(int(value))
	var last = icons.size() - 1
	
	if i == last:
		i = 0
	elif i < 0:
		i = last
	else:
		i += 1
	
	self.set_value(str(icons[i]))
	self.refresh()
	self.on_next.emit()
