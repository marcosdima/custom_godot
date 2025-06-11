extends Resource
class_name Animate

@export_group("Basic")
@export var duration: float = 0.5
@export var start_value = 0.0
@export var end_value = 1.0

var active = false
var custom_start: Vector2

func handle_start(_e: Ente) -> void:
	printerr("This function, 'handle_start', should be overwritten!")


func do(_e: Ente, _m: float) -> void:
	printerr("This function, 'do', should be overwritten!")


func execute(e: Ente) -> void:
	if active:
		return
	
	self.lock()
	
	var tween = e.create_tween()
	tween.tween_method(
		func(m: float):
			self.do(e, m),
		self.start_value,
		self.end_value,
		self.duration,
	)
	tween.finished.connect(func(): self.unlock())


func lock() -> void:
	self.active = true


func unlock() -> void:
	self.active = false
