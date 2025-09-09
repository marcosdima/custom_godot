extends LineEdit
class_name EmulateInput

func activate_with(
	content: String,
	keyboard_type: DisplayServer.VirtualKeyboardType,
) -> void:
	text = content
	caret_column = content.length()
	self.grab_focus()
	if !Alambre.is_computer():
		DisplayServer.virtual_keyboard_show(
			content,
			Rect2(),
			keyboard_type
		)
