extends Resource
class_name ImmuneSystem

enum Types {
	Animate
}

@export var latent_parasites: Array[Latent] = []

var body: Ente
var on_attack: bool = false

func init(e: Ente) -> void:
	body = e
	for parasite: Latent in latent_parasites:
		for event in parasite.at_events:
			parasite.host = e
			e.connect_event(
				event,
				func():
					self.let_parasite(parasite.kind),
			)


func let_parasite(parasite: Parasite) -> void:
	if !on_attack:
		on_attack = true
		parasite.host = body
		parasite.activate()
		parasite.released.connect(func(): on_attack = false)
