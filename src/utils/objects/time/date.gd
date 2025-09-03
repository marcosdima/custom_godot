class_name Date

## Constants used as dictionary keys
const YEAR: String = "year"
const MONTH: String = "month"
const DAY: String = "day"
const WEEKDAY: String = "weekday"

## Enumeration for weekdays (0 = Sunday, 6 = Saturday)
enum Weekday {
	Sunday,
	Monday,
	Tuesday,
	Wednesday,
	Thursday,
	Friday,
	Saturday
}

## Static property that returns the current system date/time as a Date instance
static var NOW: Date:
	get():
		return Date.from_dict(Time.get_datetime_dict_from_system())

## Year value (e.g., 2025)
var year: int

## Month value (1–12)
var month: int

## Day of the month (1–31)
var day: int

## Day of the week (uses the Weekday enum)
var weekday: Weekday

## Time component (hours, minutes, seconds) stored as ClockTime
var time: ClockTime

## Constructor, initializes the date and time with given values or defaults
func _init(
	_year: int = 1970,
	_month: int = 1,
	_day: int = 1,
	_weekday: Weekday = Weekday.Monday,
	_hours: int = 0,
	_minutes: int = 0,
	_seconds: int = 0
) -> void:
	year = _year
	month = _month
	day = _day
	weekday = _weekday
	time = ClockTime.new(_hours, _minutes, _seconds)

## Returns the date as a string in the format "YYYY-MM-DD HH:MM:SS (Weekday)"
func as_string() -> String:
	return "%04d-%02d-%02d %s (%s)" % [year, month, day, time.as_string(), Weekday.find_key(weekday)] 

## Returns the date as a dictionary including both date and time fields
func as_dictionary() -> Dictionary:
	return {
		YEAR: year,
		MONTH: month,
		DAY: day,
		WEEKDAY: weekday,
		ClockTime.HOURS: time.hours,
		ClockTime.MINUTES: time.minutes,
		ClockTime.SECONDS: time.seconds,
	}


## Returns the number of seconds from this Date to NOW.
## Positive if NOW is in the future, negative if NOW is in the past.
func seconds_to_now() -> int:
	# Convert this Date instance to a Dictionary
	var dict_this = as_dictionary()
	# Convert NOW to a Dictionary
	var dict_now = Date.NOW.as_dictionary()
	
	# Convert both dates into unix timestamps
	var unix_this = Time.get_unix_time_from_datetime_dict(dict_this)
	var unix_now = Time.get_unix_time_from_datetime_dict(dict_now)
	
	# Return difference (seconds until NOW)
	return unix_this - unix_now


## Builds a Date instance from a dictionary, extracting date and time values
static func from_dict(dictionary: Dictionary) -> Date:
	var weekday_enum = Weekday.values()[dictionary.weekday] if dictionary.has("weekday") else Weekday.Sunday
	return Date.new(
		dictionary.get(YEAR, 1970),
		dictionary.get(MONTH, 1),
		dictionary.get(DAY, 1),
		weekday_enum,
		dictionary.get(ClockTime.HOURS, 0),
		dictionary.get(ClockTime.MINUTES, 0),
		dictionary.get(ClockTime.SECONDS, 0),
	)
