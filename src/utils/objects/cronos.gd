class_name Cronos

signal on_tick
signal on_tick_nt

const MAX = 60

var seconds: int = 0:
	set(value):
		seconds = self.validate_time(value)
var minutes: int = 0:
	set(value):
		minutes = self.validate_time(value)

func _init(seconds: int = 0) -> void:
	self.set_from_seconds(seconds)


func _to_string() -> String:
	var seconds_str = str(seconds) if seconds > 9 else "0" + str(seconds)
	var minutes_str = str(minutes) if minutes > 9 else "0" + str(minutes)
	return minutes_str + ":" + seconds_str


## Validates range.
func validate_time(new_time: int) -> int:
	if new_time < 0:
		return MAX - 1
	elif new_time >= MAX:
		return 0
	else:
		return new_time


## Time pass one second.
func tick() -> void:
	if minutes == 0 and seconds == 0:
		self.emit_signal("on_tick_nt")
	else:
		if seconds == 0:
			minutes -= 1
		seconds -= 1
		self.emit_signal("on_tick")


## From the seconds provided, set minutes and seconds.
func set_from_seconds(total_seconds: int) -> void:
	minutes = total_seconds / MAX
	seconds = total_seconds % MAX
