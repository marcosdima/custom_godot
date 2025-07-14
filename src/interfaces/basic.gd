@tool
extends Component
class_name BasicInterface

const CLEAR = "CLEAR"
const LINE = "LINE"
const INPUT = "INPUT"

@export_group("Children", "")
@export var max_length: int = 10
@export var min_char_size: int = 10
@export var placeholder: String = ""
@export var numeric: bool = false
@export_group("")

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
	var input = TextInput.new()
	input.name = INPUT
	input.placeholder = self.placeholder
	input.max_length = self.max_length
	input.min_chars = self.min_char_size
	input.color = self.color
	
	if !numeric:
		input.no_numeric = true
		input.no_signs = true
		input.no_alpha = false
	else:
		input.no_numeric = false
		input.no_signs = true
		input.no_alpha = true
	
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
func modify_default_layout_config() -> void:
	self.layout.config[Sausage.VERTICAL] = true


## [OVERWRITTEN]
func modificate_space(key: String) -> void:
	var target = self.contenedor_spaces.get(key) as SausageSpace
	
	match key:
		LINE:
			target.order = 1
			target.fill = 10
		INPUT + CLEAR:
			target.order = 0
			target.fill = 90
