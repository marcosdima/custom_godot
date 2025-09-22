extends Active
class_name Do

@export var start_value: float = 0.0
@export var end_value: float = 1.0

func handle_start() -> void:
	printerr("This function, 'handle_start', should be overwritten!")


func do( _m) -> void:
	printerr("This function, 'do', should be overwritten!")


func activate() -> void:
	var tween = host.create_tween()
	tween.tween_method(
		func(m):
			self.do(m),
		start_value,
		end_value,
		duration,
	)
	tween.finished.connect(release)
