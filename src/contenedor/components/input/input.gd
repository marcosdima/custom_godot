extends Component
class_name InputComponent

@export var value: String:
	set(val):
		if self.validate_value(val):
			value = val
@export var max_lenght: int = 10:
	set(value):
		max_lenght = value
		self.handle_resize()
@export_group("Prohibit", "no_")
@export var no_alpha: bool = false
@export var no_numeric: bool = false
@export var no_signs: bool = false

func _ready() -> void:
	super()
	self.connect_event(Ente.Event.OnClick, handle_on_click)
	self.connect_event(Ente.Event.OnClickReleased, handle_on_click_released)
	self.connect_event(Ente.Event.OnFocus, handle_on_focus)
	self.connect_event(Ente.Event.OnUnfocus, handle_on_unfocus)
	self.connect_event(Ente.Event.MouseIn, handle_mouse_in)
	self.connect_event(Ente.Event.MouseOut, handle_mouse_out)
	self.connect_event(Ente.Event.MouseStill, handle_mouse_still)


func _input(event: InputEvent) -> void:
	super(event)
	
	if event is InputEventKey:
		self.handle_key_event(event)


func validate_value(new_value: String) -> bool:
	var alpha_regex = RegEx.new()
	alpha_regex.compile("[A-Za-z]")
	var contains_alpha = alpha_regex.search(new_value)
	
	var numeric_regex = RegEx.new()
	numeric_regex.compile("[0-9]")
	var contains_numeric = numeric_regex.search(new_value)

	var signs_regex = RegEx.new()
	signs_regex.compile(r"[^\w\s]")
	var contains_signs = signs_regex.search(new_value)
	
	var valid_lenght = max_lenght >= new_value.length()
	var invalid_content = (no_alpha and contains_alpha) or (no_numeric and contains_numeric) or (no_signs and contains_signs) 
	
	return valid_lenght and !invalid_content


######################  HANDLERS  ######################
# Each of this funcions is called at its related event.

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


func handle_key_event(_event: InputEventKey) -> void:
	pass


func set_value(v) -> void:
	self.value = v


## [OVERWRITE] Returns its value
func get_value():
	return self.value
