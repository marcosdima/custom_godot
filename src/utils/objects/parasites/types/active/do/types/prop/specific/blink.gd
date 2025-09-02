extends PropVariant
class_name Blink

## [OVERWRITTED]
func get_prop() -> Prop:
	var prop = super()
	prop.add_target(Prop.Properties.MODULATE_A)
	return prop
