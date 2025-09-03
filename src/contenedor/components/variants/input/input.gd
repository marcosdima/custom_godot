extends Component
class_name InputComponent

@export var value: String = ""
@export var max_length: int = 10
@export_group("Prohibit", "no_")
@export var no_alpha: bool = false
@export var no_numeric: bool = false
@export var no_signs: bool = false

func _input(event: InputEvent) -> void:
	super(event)
	
	if input_handler.focus and event is InputEventKey:
		var key = input_handler.data.values.get(InputData.KEY)
		var action = input_handler.data.values.get(InputData.ACTION)
		
		if key and self.validate_value(key):
			self.handle_key(key)
		elif action:
			self.handle_some_action(action, event.is_pressed())


## [OVERWRITE] What to do if value was cleaned.
func clear_input() -> void:
	value = ""
	self.handle_resize()


## [OVERWRITE] What to do at event key.
func handle_key(_key: String) -> void:
	pass


## [OVERWRITE] What to do at some action.
func handle_some_action(_action: InputData.Action, _pressed: bool) -> void:
	pass


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
	
	var valid_lenght = max_length >= (value + new_value).length()
	var invalid_content = (no_alpha and contains_alpha) or (no_numeric and contains_numeric) or (no_signs and contains_signs) 
	
	return valid_lenght and !invalid_content


func set_value(v) -> void:
	if self.validate_value(v):
		self.value = v
