extends Text
class_name TimeText

var time: ClockTime
var set_display: ClockTime.DisplayWith

func _init(
	time_: ClockTime = ClockTime.new(),
	set_display_: ClockTime.DisplayWith = ClockTime.DisplayWith.Hours,
) -> void:
	time = time_
	set_display = set_display_
	content = time.as_string(set_display)


func set_new_time(new_time: ClockTime) -> void:
	time = new_time
	self.update_text(time.as_string(set_display))
