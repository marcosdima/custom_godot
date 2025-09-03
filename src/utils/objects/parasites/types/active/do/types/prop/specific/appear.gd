extends PropVariant
class_name Appear

## [OVERWRITTED]
func get_prop() -> Prop:
	var prop = super()
	prop.add_target(Prop.Properties.MODULATE_A)
	prop.end_value = 1.0
	prop.start_value = 0.0
	return prop
