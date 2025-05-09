@tool
extends Component
class_name Text

'''╭─[ Export Variables ]──────────────────────────────────────────────────────────────────╮'''
@export var content: String = ""
@export var font: FontFile
@export var font_size: int = 50
@export var text_animations: Dictionary = {}

'''╭─[ Variables ]─────────────────────────────────────────────────────────────────────────╮'''
var area: Contenedor
var text_animator: TextAnimationHandler
var max_font_size: float = 0
var draw_n_chars: int
var draw_last_char_at: float = -1

'''╭─[ Lifecycle Functions ]───────────────────────────────────────────────────────────────╮'''
func _ready() -> void:
	super()
	self.set_area()
	self.set_max_font_size()
	self.text_animator = TextAnimationHandler.new(self)
	self.text_animator.handle_connect()
	self.draw_n_chars = -1


func _init() -> void:
	super()
	self.text_animator = TextAnimationHandler.new(self)
	self.text_animator.handle_connect()


func _draw():
	super()
	
	var move_flag = self.draw_n_chars > -1
	
	var text_content = self.content if !move_flag else self.content.substr(0, self.draw_n_chars)
	var text_size = self.get_text_size(text_content) 
	var contenedor_size = self.get_real_size()
	
	# Calculate the center of the contenedor and moves it to the left half text_size.
	var pos_x = (contenedor_size.x - text_size.x) * 0.5
	
	# Caculate the right point to set the hight of the text.
	var f_size = self.get_font_size_unit() * self.font_size
	var metrics = self.font.get_ascent(f_size) - self.font.get_descent(f_size)
	var pos_y = (contenedor_size.y + metrics) * 0.52
	
	draw_string(
		self.font,
		Margin.start(self) + Vector2(pos_x, pos_y),
		text_content,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		f_size,
		self.color
	)
	
	if move_flag and draw_n_chars < self.content.length() and self.draw_last_char_at < 1:
		draw_string(
			self.font,
			Margin.start(self) + Vector2(pos_x + text_size.x, pos_y * self.draw_last_char_at),
			self.content[draw_n_chars],
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			f_size,
			self.color
		)


'''╭─[ Setters and Getters  ]──────────────────────────────────────────────────────────────╮'''
func set_area() -> void:
	var new_area = Contenedor.new()
	new_area.layout_type = Instantiator.LayoutType.Rail
	new_area.set_real_position(self.get_real_position())
	new_area.set_real_size(self.get_real_size())
	new_area._set_layout()
	new_area.background = Color.REBECCA_PURPLE
	
	self.area = new_area


func get_text_size(s: String) -> Vector2:
	return self.font.get_string_size(
		s,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		self.get_font_size_unit() * self.font_size as int
	)


func get_font_size_unit() -> float:
	return float(self.max_font_size) / 100.0 if self.max_font_size > 0 else 10


func set_max_font_size() -> void:
	var size_a = self.font.get_string_size(
		self.content,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		1
	).x
	var our_size = self.get_real_size().x
	
	self.max_font_size = our_size / size_a


'''╭─[ Methods ]───────────────────────────────────────────────────────────────────────────╮'''
func overflow() -> bool:
	return self.get_text_size(self.content).x > self.get_real_size().x


func has_point(point: Vector2) -> bool:
	return self.text_area.has_point(point)


'''╭─[ To-Overwrite methods ]───────────────────────────────────────────────────────────────╮'''
func editor_settings() -> void:
	super()
	self.set_area()
	self.set_max_font_size()
	self.text_animator = TextAnimationHandler.new(self)
	self.draw_n_chars = -1
