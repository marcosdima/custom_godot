extends Component
class_name InputComponent

@export var value: String
@export var max_length: int = 10:
	set(value):
		max_length = value
		self.handle_resize()
@export_group("Prohibit", "no_")
@export var no_alpha: bool = false
@export var no_numeric: bool = false
@export var no_signs: bool = false

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
	
	var valid_lenght = max_length >= new_value.length()
	var invalid_content = (no_alpha and contains_alpha) or (no_numeric and contains_numeric) or (no_signs and contains_signs) 
	
	return valid_lenght and !invalid_content


func handle_key_event(_event: InputEventKey) -> void:
	pass


func set_value(v) -> void:
	if self.validate_value(v):
		self.value = v


## [OVERWRITE] What to do if value was cleaned.
func clear_input() -> void:
	self.value = ""
