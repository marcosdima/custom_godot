@tool
extends Resource
class_name EnteResource

@export_group("Ente", "")
@export var immune_system: ImmuneSystem = ImmuneSystem.new()
@export var margin: Margin = Margin.new()
@export_subgroup("Background", "background_")
@export var background_color: Color = Color.TRANSPARENT
@export var background_border: Border = Border.new()
@export_group("", "")

func apply(ente: Ente):
	ente.immune_system = immune_system
	ente.margin = margin
	ente.background_color = background_color
	ente.background_border = background_border
