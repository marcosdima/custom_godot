extends Component
class_name InputComponent

var value

func _ready() -> void:
	super()
	self.connect_event(Ente.Event.OnClick, handle_on_click)
	self.connect_event(Ente.Event.OnClickReleased, handle_on_click_released)
	self.connect_event(Ente.Event.OnFocus, handle_on_focus)
	self.connect_event(Ente.Event.OnUnfocus, handle_on_unfocus)
	self.connect_event(Ente.Event.MouseIn, handle_mouse_in)
	self.connect_event(Ente.Event.MouseOut, handle_mouse_out)
	self.connect_event(Ente.Event.MouseStill, handle_mouse_still)


func handle_on_click() -> void:
	pass


func handle_on_click_released() -> void:
	pass


func handle_on_focus() -> void:
	pass


func handle_on_unfocus() -> void:
	pass


func handle_mouse_in() -> void:
	pass


func handle_mouse_out() -> void:
	pass


func handle_mouse_still() -> void:
	pass


func set_value(v) -> void:
	self.value = v


## [OVERWRITE] Returns its value
func get_value():
	return self.value
