extends BaseAnimType
class_name  AnimationType

@export var do: AnimationHandler.Do = AnimationHandler.Do.Nothing

func get_key() -> String:
	if self.do:
		self.set_key(AnimationHandler.Do.find_key(self.do))
	return super()
