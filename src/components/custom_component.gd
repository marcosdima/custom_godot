extends Element

class_name CustomComponent

@export var back_ground: Color = Color.TRANSPARENT
@export var color: Color = Color.RED

@export_group("Border")
@export var border_color: Color = Color.TRANSPARENT
@export var border_width: float = 1.0

var curr_color: Color
var hover_l: float = 0.5
var click_l: float = 0.4

func _ready() -> void:
	self.curr_color = self.color


func _draw():
	# Draw bg.
	var background = Rect2(Vector2.ZERO, self.size) 
	draw_rect(background, self.back_ground, true)
	
	# Draw margin rect.
	var r = self.size * 0.1
	var rect = Rect2(r,  self.size - (r * 2))
	draw_rect(rect.grow(self.border_width), self.border_color, false)
	
	super()


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
