extends BaseAnimType
class_name TextAnimationType

@export var do: TextAnimationHandler.TextDo

func get_key() -> String:
	if self.do:
		self.set_key(TextAnimationHandler.TextDo.find_key(self.do))
	return super()
