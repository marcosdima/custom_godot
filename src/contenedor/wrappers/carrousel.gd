@tool
extends Contenedor
class_name Carrousel

@export var next_action: bool = false:
	set(value):
		next_action = false
		self.next()

func next() -> void:
	var ly = self.layout as Pages
	ly.on_page += 1
	self.handle_resize()


func prev() -> void:
	var ly = self.layout as Pages
	ly.on_page -= 1
	self.handle_resize()
