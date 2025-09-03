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
			Vector2(0, text_size.y * 0.85), # TODO: Harcoded value.
			value,
			text.get_font_size(),
			font_color
		)


func _init(t: Text, v: String, r: int, c: int, str_pos: int) -> void:
	super()
	text = t
	font = t.font
	column = c
	row = r
	value = v
	name = str(r) + str(c)
	pos = str_pos


func get_char_size(f_size:int = 0) -> Vector2:
	var aux = f_size if f_size else text.get_font_size()
	return font.get_string_size(
		value,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		aux,
	)
