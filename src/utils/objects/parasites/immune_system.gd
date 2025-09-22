extends Resource
class_name ImmuneSystem

enum Types {
	Animate
}

@export var latent_parasites: Array[Latent] = []

var body: Ente
var on_attack: Parasite
var queue: Array[Parasite] = []

func init(e: Ente) -> void:
	body = e
	for parasite: Latent in latent_parasites:
		for event in parasite.at_events:
			parasite.host = e
			e.connect_event(
				event,
				func():
					self.let_parasite(parasite),
			)


func let_parasite(parasite: Parasite) -> void:
	if !on_attack:
		self._set_parasite(parasite)
	else:
		queue.append(parasite)


func _next() -> void:
	self._purge()
	if !queue.is_empty():
		var p = queue.pop_front()
		self._set_parasite(p)


func _set_parasite(parasite: Parasite):
	on_attack = parasite
	parasite.host = body
	parasite.activate()
	parasite.released.connect(_next)


func _purge():
	on_attack.released.disconnect(_next)
	on_attack = null
