@tool
extends Node

class_name Instantiator

## Handles script load.
static func _load_script(path: String) -> RefCounted:
	var script = load(path)
	var instance = script.new()
	return instance


'''╭─[ Layout  ]───────────────────────────────────────────────────────────────────────────╮'''
enum LayoutType {
	Grid,
	Rail,
}

## Instantiate a layout node.
static func instantiate_layout(t: LayoutType) -> RefCounted:
	var layout = Instantiator._load_script(Instantiator.get_path_from(t))
	return layout


static func get_path_from(t: LayoutType) -> String:
	var base = "res://src/layouts/types/"
	
	match t:
		LayoutType.Grid: base += "grid_layout.gd"
		LayoutType.Rail: base += "rail_layout.gd"
		_: base += "NON_HANDLED"
	
	return base
