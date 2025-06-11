extends Resource
class_name AnimateContenedor

@export var do: ContenedorAnimator.AnimationsC = ContenedorAnimator.AnimationsC.Simple
@export var delay: float = 0
@export var animate_wrapper: AnimateWrapper

func _init() -> void:
	self.animate_wrapper = AnimateWrapper.new()
