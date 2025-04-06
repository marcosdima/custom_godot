extends Element

class_name CustomButton

@export var color: Color = Color.RED
@export var border: Color = Color.TRANSPARENT

var curr_color: Color
var hover_l: float = 0.5
var click_l: float = 0.4

func _ready() -> void:
	self.curr_color = self.color


func _draw():
	var style_box = StyleBoxFlat.new()
	
	# Use export vars
	style_box.bg_color = self.curr_color
	
	if self.border != Color.TRANSPARENT:
		self.border_color = self.border
		style_box.border_width_bottom = 2
		style_box.border_width_right = 2
	
	style_box.set_corner_radius_all(8)
	draw_style_box(style_box, Rect2(Vector2.ZERO, self.size))


func handle_mouse_on():
	self.curr_color = self._color_from(self.hover_l)
	queue_redraw()


func handle_on_mouse_out():
	self.curr_color = self.color
	queue_redraw()


func handle_click(pos: Vector2):
	self.curr_color = self._color_from(self.click_l)
	queue_redraw()


func handle_release_click():
	self.curr_color = self._color_from(self.hover_l)
	queue_redraw()


func _color_from(l: float) -> Color:
	return Color.from_hsv(self.curr_color.h, self.curr_color.s, l)
