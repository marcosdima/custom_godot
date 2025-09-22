@tool
extends Display
class_name TextDisplay

const TEXT = "Text"

@export var text: TextResourse = TextResourse.new()

var text_display: Text

## [OVERWRITTEN] From: Component
func get_children_to_set() -> Array:
	text_display = Text.new()
	text_display.name = TEXT
	text_display.color = color
	text.apply(text_display)
	return [text_display]
