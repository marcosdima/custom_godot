extends Control
class_name Ancestor

@warning_ignore("unused_signal")
signal resize
@warning_ignore("unused_signal")
signal on_ready
@warning_ignore("unused_signal")
signal on_click
@warning_ignore("unused_signal")
signal on_click_released
@warning_ignore("unused_signal")
signal on_focus
@warning_ignore("unused_signal")
signal on_unfocus
@warning_ignore("unused_signal")
signal mouse_in
@warning_ignore("unused_signal")
signal mouse_out
@warning_ignore("unused_signal")
signal mouse_still

static var _count = 0
var id: int
var input_handler: InputHandler

func _ready() -> void:
	Ancestor._count = 1 if !Ancestor._count else Ancestor._count + 1
	self.id = Ancestor._count
	self.input_handler = InputHandler.new(self as Ente) ## TOFIX: Wierd...


func _input(event: InputEvent) -> void:
	self.input_handler.handle_input(event)


func get_fosil() -> int:
	return self.id


''' PRINT METHODS'''
## Display object data.
func p() -> void:
	Printea.print(self)


## Display InputEvent data.
func p_event(e: InputEvent) -> void:
	Printea.print_event(e)
