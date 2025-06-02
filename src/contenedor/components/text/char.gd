extends Ente
class_name Char

var value: String
var line: int
var text: Text

func _ready() -> void:
	#self.test_border = true
	super()
	self.text = self.get_parent()


func _draw():
	super()
	
	var parent = self.text
	var font = parent.font
	
	if font:
		var font_size = parent.get_font_size()
		var font_color = parent.font_color
		var text_size = parent.get_char_size(self.value, font_size)
		
		var metrics = font.get_ascent(font_size) - font.get_descent(font_size)
		
		draw_char(
			font,
			text_size * Vector2(0, 1),
			self.value,
			metrics,
			font_color
		)
