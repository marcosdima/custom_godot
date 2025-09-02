extends Active
class_name PropVariant

## [OVERWRITE] Get prop.
func get_prop() -> Prop:
	var prop = Prop.new(duration)
	prop.host = host
	prop.released.connect(func(): self.release())
	return prop


## [OVERWRITTED] From: Parasite.
func activate() -> void:
	var prop = get_prop()
	prop.activate()
