@tool
extends Component
class_name Cronometer

signal ended

const MAX = 3660
const TIME = "TIME"
const PLAY = "PLAY"

@export var start: bool = false:
	set(value):
		if value:
			play.set_default(Icon.DefaultIcons.Square)
			timer.start()
@export var set_cronos_time: int = 0:
	set(value):
		set_cronos_time = value if value > 0 else 0
		cronos.set_from_seconds(set_cronos_time)

var cronos: Cronos = Cronos.new()
var timer: ManualTimer

var time: Text
var play: Icon

func _init() -> void:
	super()
	timer = ManualTimer.new(1.0, cronos.tick, true)
	cronos.on_tick.connect(handle_tick)
	cronos.on_tick_nt.connect(handle_end)


## [OVERWRITTED]
func get_layout_type() -> Layout.LayoutType:
	return Layout.LayoutType.Sausage


## [OVERWRITTED]
func get_children_to_set() -> Array:
	time = Text.new()
	time.name = TIME
	time.font_proportional_size = 50
	time.content = str(cronos)
	time.placement_axis_x = Placement.Middle
	time.placement_axis_y = Placement.Middle
	time.margin = Margin.new(0, 10)
	time.color = color
	
	play = Icon.new()
	play.name = PLAY
	play.color = color
	play.on_click_released.connect(
		func():
			if !timer.running:
				start = true
			else:
				self.handle_end()
	)
	
	return [time, play]


## [OVERWRITTED]
func get_layout_spaces() -> Dictionary:
	for s: SausageSpace in layout.spaces.values():
		match s.name:
			TIME:
				s.fill = 70
			PLAY:
				s.fill = 30
	return layout.spaces


## [OVERWRITTED] 
func get_layout_config() -> Dictionary:
	return {
		Sausage.VERTICAL: false,
		Sausage.SPACE_BETWEEN: 0,
	}


func set_time() -> void:
	cronos.set_from_seconds(set_cronos_time)
	time.content = str(cronos)
	time.refresh()


func handle_tick() -> void:
	if time:
		time.content = str(cronos)
		time.refresh()


func handle_end() -> void:
	timer.stop()
	self.set_time()
	play.set_default(Icon.DefaultIcons.Play)
	self.ended.emit()
