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
@export var set_cronos_time: int = 0:
	set(value):
		set_cronos_time = value
		cronos.set_from_seconds(set_cronos_time)

var cronos: Cronos = Cronos.new()
var timer: Timer = Timer.new()

var time: Text
var play: Icon

func _ready() -> void:
	super()
	
	timer.wait_time = 1.0
	timer.one_shot = false
	self.add_child.call_deferred(timer)
	timer.timeout.connect(cronos.tick)
	
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
			if timer.is_stopped():
				play.set_default(Icon.DefaultIcons.Square)
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
	time.content = str(cronos)
	time.refresh()


func handle_end() -> void:
	timer.stop()
	self.set_time()
	play.set_default(Icon.DefaultIcons.Play)
