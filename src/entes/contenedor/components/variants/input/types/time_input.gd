extends TextInput
class_name TimeInput

var display: ClockTime.DisplayWith = ClockTime.DisplayWith.Hours
var time: ClockTime

func _init(
	display_: ClockTime.DisplayWith = ClockTime.DisplayWith.Hours
) -> void:
	no_numeric = false
	no_alpha = true
	no_alpha = true
	keyboard_type = DisplayServer.VirtualKeyboardType.KEYBOARD_TYPE_NUMBER_DECIMAL
	
	display = display_
	max_length = 2 * (display + 1)
	time = ClockTime.new()
	
	super()


## [OVERWRITTEN] from TextInput
func update_content() -> void:
	self._parse_value_to_seconds()
	if content:
		content.set_new_time(time)


## [OVERWRITTEN] from TextInput
func get_text(t_name: String, t_content: String, new_text = Text.new()) -> Text:
	if t_name == CONTENT:
		var time_text = TimeText.new(time, display)
		return super(t_name, time.as_string(display), time_text)
	else:
		return super(t_name, t_content, new_text)


func _parse_value_to_seconds() -> void:
	var acc = 0
	var aux_exponent = 0
	var aux_number = ""
	var len = value.length()
	
	for i in range(len):
		aux_number = value[i] + aux_number
		if i % 2 == 1 or i == len - 1:
			acc += int(aux_number) * (60 ** aux_exponent) 
			aux_exponent += 1
			aux_number = ""
	
	time = ClockTime.from_seconds(acc)
