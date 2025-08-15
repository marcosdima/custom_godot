extends Ente
class_name Char

var value: String
var pos: int

# Position.
var row: int
var column: int

var text: Text
var font = Font

func _draw():
	super()
	
	if font:
		var font_color = text.color
		var text_size = self.get_char_size()
		
		draw_char(
			font,
			Vector2(0, text_size.y * 0.75),
			value,
			text.font_size,
			font_color
		)


func set_from(t: Text, v: String, r: int, c: int, str_pos: int) -> void:
	self.text = t
	self.font = t.font
	self.column = c
	self.row = r
	self.value = v
	self.name = str(r) + str(c)
	self.pos = str_pos


func get_char_size() -> Vector2:
	return self.font.get_string_size(
		value,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		text.font_size,
	)
