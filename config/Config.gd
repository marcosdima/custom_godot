class_name Config

enum ElementConfig {
	Contenedor,
	RailLayoutContenedor,
	GridLayoutContenedor,
	GridLayoutElement,
	SausageContenedor,
	SausageLayoutContenedor,
	SausageLayoutElement,
	NONE,
}

## Exported configuration dictionary
static var data = {}

'''╭─[ Methods ]───────────────────────────────────────────────────────────────────────────╮'''
## Load config from JSON file
static func load_config(e: ElementConfig):
	var config_path = Config.get_config_path(e)
	var key = Config.get_key(e)
	
	if FileAccess.file_exists(config_path):
		# Open config file.
		var file = FileAccess.open(config_path, FileAccess.READ)

		# Parse file data as JSON.
		var result = JSON.parse_string(file.get_as_text())
		
		# If the JSON is a dictionary...
		if typeof(result) == TYPE_DICTIONARY:
			# Parse each field to its type...
			for k in result.keys():
				var value = ConfigField.new(k, result[k])
				result[k] = value.parse_from()
			
			# If data exists...
			if Config.data:
				Config.data[key] = result
			else:
				Config.data = { key: result }
		else:
			push_error("Invalid JSON format.")
	else:
		push_warning("Config file not found.")


## Check if there are differences between keys.
static func update(target: ElementConfig, curr: Dictionary) -> Dictionary:
	var target_key = Config.get_key(target)
	
	if !Config.data or !Config.data.has(target_key):
		Config.load_config(target)
	
	# Get target data keys.
	var new = Config.data[target_key]
	var new_keys = new.keys()
	new_keys.sort()
	
	# Get current fields keys.
	var curr_keys = curr.keys() 
	curr_keys.sort()
	
	# If both dictionaries have the same keys, nothing happens.
	if new_keys == curr_keys:
		return curr
	
	# Else, update curr.
	var aux = curr.duplicate()
	
	# Merge dictionaries, so new keys are added.
	aux.merge(new, false)
	
	# Delete keys that are not present in the new data.
	var to_erase = curr_keys.filter(func (k): return !new_keys.has(k))
	
	for k in to_erase:
		aux.erase(k)
	
	return aux


'''╭─[ Setters and Getters ]───────────────────────────────────────────────────────────────╮'''
## Returns 
static func get_config(e: ElementConfig) -> Dictionary:
	var key = Config.get_key(e)
	
	if !Config.data or !Config.data.has(key):
		Config.load_config(e)
	
	return Config.data[key]


## From ElementConfig enum get its configuration file path.
static func get_config_path(e: ElementConfig) -> String:
	return "res://addons/custom_godot/config/files/" + Config.get_key(e) + ".json"


## From ElementConfig enum get its data key.
static func get_key(e: ElementConfig) -> String:
	return ElementConfig.find_key(e).to_snake_case()
