extends Ente
class_name Char

var value: String

# Position.
var row: int
var column: int

var text: Text
var font = Font

func _ready() -> void:
	super()
	self.text = self.get_parent()
	self.font = self.text.font


func _draw():
	super()
	
	var parent = self.text
	
	if self.font:
		var font_color = parent.font_color
		
		draw_char(
			self.font,
			self.get_position_from_placement(),
			self.value,
			parent.get_font_size(),
			font_color
		)


func get_position_from_placement() -> Vector2:
	var text_size = self.text.get_char_size(self)
	# TOFIX: Magic number!
	return Vector2(0, text_size.y / 1.3)


func set_from(t: Text, v: String, r: int, c: int) -> void:
	self.text = t
	self.font = t.font
	self.column = c
	self.row = r
	self.value = v
	self.name = str(r) + str(c)
