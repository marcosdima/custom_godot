extends Latent
class_name Hive

@export var delay: float = 0.0
@export var delay_start: float = 0.0

## [OVERWRITTED]
func valid_ente() -> bool:
	return host.body is Component


## [OVERWRITTED]
func activate() -> void:
	var component = host as Component
	await set_timeout(delay_start)
	
	for c: Ente in component.contenedor.contenedor_entes.values():
		c.parasites.let_parasite(kind.duplicate())
		await set_timeout(delay)
	
	self.release()
