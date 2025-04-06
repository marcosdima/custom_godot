extends Element

class_name CustomLabel

@export var text: String = ""
@export var font: Font
@export var font_size: int = 16
@export var font_color: Color = Color.BLACK

func _draw():
	var text_size = self.font.get_string_size(
		self.text,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		self.font_size
	)
	var contenedor_size = self.size
	
	# Calculate the center of the contenedor and moves it to the left half text_size.
	var pos_x = (contenedor_size.x - text_size.x) * 0.5
	
	# Caculate the right point to set the hight of the text.
	var metrics = self.font.get_ascent(self.font_size) - self.font.get_descent(self.font_size)
	var pos_y = (contenedor_size.y + metrics) * 0.5
	
	draw_string(
		self.font,
		Vector2(pos_x, pos_y),
		self.text,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		self.font_size,
		Color.BLACK
	)


func handle_mouse_on():
	#self.curr_color = self._color_from(self.hover_l)
	queue_redraw()


func handle_on_mouse_out():
	self.curr_color = self.color
	queue_redraw()


func handle_click(pos: Vector2):
	#self.curr_color = self._color_from(self.click_l)
	queue_redraw()


func handle_release_click():
	#self.curr_color = self._color_from(self.hover_l)
	queue_redraw()
