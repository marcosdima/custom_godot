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

static var SPACES: Dictionary
static var instance: SpaceManager

static func execute(c: Contenedor, a: Action, data={}):
	# Singleton.
	if !instance:
		instance = SpaceManager.new()
	
	var key = c.name
	var exists_spaces = SpaceManager.exists(key)
	var result
	
	match a:
		Action.Create: result = instance.create(key, data)
		Action.Save: result = instance.save(key, data[SAVE])
		Action.Delete: result = instance.delete(key, data[DELETE]) if exists_spaces else []
		Action.Clean: result = instance.clean(key)
		Action.Get: result = instance.get_spaces(key) if exists_spaces else {}
	
	return result



static func exists(key: String) -> bool:
	return SPACES.has(key)


func create(key: String, new_spaces: Dictionary):
	SPACES[key] = new_spaces


func delete(key: String, keys: Array):
	var new = instance.get_duplicate(key)
	for k in keys:
		new.erase(k)
	SPACES[key] = new


func save(key: String, spaces_updated: Dictionary ):
	var curr = SPACES[key]
	for space in spaces_updated:
		curr[space] = spaces_updated[space]


func clean(key: String):
	SPACES.erase(key)


func get_duplicate(s: String) -> Dictionary:
	return SPACES[s].duplicate()


func get_spaces(key: String) -> Dictionary:
	return SPACES[key]
