@tool
extends Display
class_name TextDisplay

const TEXT = "Text"

@export var text: TextResourse:
	get():
		if !text:
			text = TextResourse.new()
		return text

var text_display: Text

## [OVERWRITTEN] From: Component
func get_children_to_set() -> Array:
	text_display = Text.new()
	text_display.name = TEXT
	text_display.set_from_resource(text)
	text_display.color = color
	return [text_display]
