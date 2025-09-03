extends Parasite
class_name Latent

@export var at_events: Array[Ente.Event]
@export var kind: Active

## [OVERWRITTED]
func activate() -> void:
	host.immune_system.let_parasite(kind)
