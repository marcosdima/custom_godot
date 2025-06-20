@tool
extends Component
class_name BasicInterface

const CLEAR = "CLEAR"
const LINE = "LINE"
const INPUT = "INPUT"

@export var color: Color = Color.CORNFLOWER_BLUE

@export_group("Children", "c_")
@export var max_length: int = 10

func _ready() -> void:
	super()
	self.handle_resize()


## [OVERWRITTEN]
func get_layout_type() -> Layout.LayoutType:
	return Layout.LayoutType.Sausage


## [OVERWRITTEN]
func get_component_children() -> Array:
	# Line.
	var line = Ente.new()
	line.name = LINE
	line.background_color = self.color
	line.background_border.radius = 50
	
	# Input.
	var input = TextInput.new(self.color, "Write...")
	input.name = INPUT
	input.max_length = self.max_length
	input.no_alpha = true
	input.no_signs = true
	
	# Clear Icon.
	var icon = Icon.new()
	icon.name = CLEAR
	icon.default = Icon.DefaultIcons.Clear
	icon.color = self.color
	icon.connect_event(Event.OnClick, func(): input.clear_input())
	
	# Line-Clear wrapper.
	var input_space = SausageSpace.new()
	input_space.fill = 80
	input_space.order = 0
	
	var clear_space = SausageSpace.new()
	clear_space.fill = 20
	clear_space.order = 1
	var wrapp = Wrapper.new(
		[input, icon],
		{
			Sausage.VERTICAL: false,
		},
		{
			INPUT: input_space,
			CLEAR: clear_space,
		},
		Layout.LayoutType.Sausage,
	)
	wrapp.name = INPUT + CLEAR
	
	return [wrapp, line]


## [OVERWRITTEN]
func modify_default_layout_config(_curr_config: Dictionary) -> void:
	_curr_config[Sausage.VERTICAL] = true


## [OVERWRITTEN]
func modificate_space(key: String, space: Space) -> Space:
	var target = space as SausageSpace
	
	match key:
		LINE:
			target.order = 1
			target.fill = 10
		INPUT + CLEAR:
			target.order = 0
			target.fill = 90
	return super(key, target)
