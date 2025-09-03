class_name ClockTime

## Constants used as dictionary keys
const HOURS: String = "hour"
const MINUTES: String = "minute"
const SECONDS: String = "second"

## Stores the hour (0–23)
var hours: int:
	set(value):
		## Clamp the value to valid hour range
		if value < 0:
			hours = 0
		elif value > 23:
			hours = 23
		else:
			hours = value

## Stores the minutes (0–59)
var minutes: int:
	set(value):
		## Clamp the value to valid minute range
		if value < 0:
			minutes = 0
		elif value > 59:
			minutes = 59
		else:
			minutes = value

## Stores the seconds (0–59)
var seconds: int:
	set(value):
		## Clamp the value to valid second range
		if value < 0:
			seconds = 0
		elif value > 59:
			seconds = 59
		else:
			seconds = value

## Constructor, initializes with default values 0:0:0 or with given parameters
func _init(_hours: int = 0, _minutes: int = 0, _seconds: int = 0) -> void:
	hours = _hours
	minutes = _minutes
	seconds = _seconds


## Returns the time as a string in "HH:MM:SS" format
func as_string() -> String:
	return "%02d:%02d:%02d" % [hours, minutes, seconds]


## Returns the time as a dictionary { "hour": h, "minute": m, "second": s }
func as_dictionary() -> Dictionary:
	return {
		HOURS: hours,
		MINUTES: minutes,
		SECONDS: seconds
	}


## Sets the time fields from a total number of seconds
func set_from_seconds(total_seconds: int) -> void:
	hours = int(total_seconds / 3600)
	var remaining = total_seconds % 3600
	minutes = int(remaining / 60)
	seconds = remaining % 60


## Returns the total number of seconds represented by this time
func as_seconds() -> int:
	return hours * 3600 + minutes * 60 + seconds


## Builds a ClockTime from a dictionary { "hour": h, "minute": m, "second": s }
static func from_dictionary(dictionary: Dictionary) -> ClockTime:
	return ClockTime.new(
		dictionary.get(HOURS, 0),
		dictionary.get(MINUTES, 0),
		dictionary.get(SECONDS, 0)
	)
