extends Ente
class_name Char

var value: String

# Position.
var row: int
var column: int

var text: Text
var font = Font

func _ready() -> void:
	self.test_border = true
	super()
	self.text = self.get_parent()
	self.font = self.text.font


func _draw():
	super()
	
	var parent = self.text
	
	if self.font:
		var font_size = parent.get_font_size()
		var font_color = parent.font_color
		
		var metrics = self.get_metrics(font_size)
		
		draw_char(
			self.font,
			self.get_position_from_placement(),
			self.value,
			metrics,
			font_color
		)


func get_position_from_placement() -> Vector2:
	var font_size = self.text.get_font_size()
	var text_size = self.text.get_char_size(self.value, font_size)
	return Vector2(0, text_size.y / 1.5)


func get_metrics(s: float) -> float:
	return self.font.get_ascent(s) - self.font.get_descent(s)


func set_from(t: Text, v: String, r: int, c: int) -> void:
	self.text = t
	self.font = t.font
	self.column = c
	self.row = r
	self.value = v
	self.name = str(r) + str(c)
