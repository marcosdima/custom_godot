class_name SpaceManager

## This is a prototype, probably evolving to a database.

enum Action {
	Save,
	Delete,
	Create,
	Clean,
	Get,
}

const DELETE = "DELETE"
const SAVE = "SAVE"
const GET = "GET"

## In-Keys
const IN = "IN"
const KEYS = "KEYS"

var spaces: Dictionary
var contenedor: Contenedor

func _init(c: Contenedor) -> void:
	self.contenedor = c


func execute(a: Action, data={}):
	var result
	
	match a:
		Action.Create: result = self.create(data)
		Action.Save: result = self.save(data[SAVE])
		Action.Delete:
			var delete_data = data[DELETE]
			var keys = delete_data[KEYS]
			var delete_if_in = data[DELETE][IN] if delete_data.has(IN) else true
			result = self.delete(keys, delete_if_in)
		Action.Clean: result = self.clean()
		Action.Get:
			var get_data = data[GET] if data.has(GET) else func(a, b): return a.order < b.order
			result = self.get_spaces(get_data)
	
	return result


func create(new_spaces: Dictionary):
	spaces = new_spaces


func delete(keys: Array, delete_if_in: bool):
	var spaces_keys = spaces.keys()
	for k in spaces_keys:
		var is_inside = keys.find_custom(func(a): return a == k) >= 0
		if is_inside == delete_if_in:
			spaces.erase(k)


func save(spaces_updated: Dictionary ):
	for space in spaces_updated:
		spaces[space] = spaces_updated[space]


func clean():
	spaces.clear()


func get_spaces(sort_by: Callable) -> Array:
	var sorted = spaces.values()
	sorted.sort_custom(sort_by)
	return sorted
