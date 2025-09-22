extends Ente
class_name Char

var value: String
var pos: int
var text: Text

# Position.
var row: int
var column: int

func _draw():
	super()
	if text and text.font:
		var font_color = text.color
		var text_size = self.get_char_size()
		
		draw_char(
			text.font,
			Vector2(0, text_size.y * 0.85), # TODO: Harcoded value.
			value,
			text.get_font_size(),
			font_color
		)


func setup(
	text_: Text,
	value_: String = '.',
	row_: int = 0,
	column_: int = 0,
	str_pos: int = 0,
) -> Char:
	text = text_
	value = value_
	row = row_
	column = column_
	name = str(row) + str(column)
	pos = str_pos
	return self


func get_char_size(f_size:int = 0) -> Vector2:
	var aux = f_size if f_size else text.get_font_size()
	return text.font.get_string_size(
		value,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		aux,
	)
