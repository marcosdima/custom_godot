@tool
extends Component
class_name Cronometer

const MAX = 3660
const TIME = "TIME"
const PLAY = "PLAY"

@export var start: bool = false:
	set(value):
		if value:
			timer.start()
@export var set_timer: int = 0:
	set(value):
		if value:
			cronos.set_from_seconds(value)
			self.set_time()
			set_timer = value

var cronos: Cronos = Cronos.new()
var timer: Timer = Timer.new()

var time: Text

func _ready() -> void:
	super()
	
	timer.wait_time = 1.0
	timer.one_shot = false
	self.add_child.call_deferred(timer)
	timer.timeout.connect(cronos.tick)
	
	cronos.on_tick.connect(
		func():
			time.content = str(cronos)
			time.refresh()
	)
	
	cronos.on_tick_nt.connect(
		func():
			timer.stop()
			set_timer = set_timer
	)


## [OVERWRITTED]
func get_layout_type() -> Layout.LayoutType:
	return Layout.LayoutType.Sausage


## [OVERWRITTED]
func get_children_to_set() -> Array:
	time = Text.new()
	time.name = TIME
	time.font_size = 200
	time.content = str(cronos)
	return [time]


## [OVERWRITTED]
func get_layout_spaces() -> Dictionary:
	for s: SausageSpace in layout.spaces.values():
		match s.name:
			TIME:
				s.fill = 100
	return layout.spaces


## [OVERWRITTED] 
func get_layout_config() -> Dictionary:
	return {
		Sausage.VERTICAL: false,
		Sausage.SPACE_BETWEEN: 0,
	}


func set_time() -> void:
	time.content = str(cronos)
	time.refresh()
