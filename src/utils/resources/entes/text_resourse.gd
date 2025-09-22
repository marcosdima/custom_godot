@tool
extends ComponentResourse
class_name TextResourse

@export_group("Text", "")
@export var content: String = ""
@export var font_size: int = 0
@export var font_proportional_size: int = 100
@export var min_chars: int = 0
@export var font: FontFile = load("res://static/fonts/CaviarDreams.ttf")
@export_group("", "")

func apply(ente: Ente):
	super(ente)
	
	var text = ente as Text
	if !text:
		printerr("Expected Text but received: ", ente)
		return
	
	text.content = content
	text.font_size = font_size
	text.font_proportional_size = font_proportional_size
	text.min_content_lenght = min_chars
	text.font = font
