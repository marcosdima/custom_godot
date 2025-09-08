extends Resource
class_name TextResourse

@export var content: String = ""
@export var font_size: int = 0
@export var font_proportional_size: int = 100
@export var min_chars: int = 0
@export_subgroup("Placement", "")
@export var horizontal: Contenedor.Placement = Contenedor.Placement.Middle
@export var vertical: Contenedor.Placement = Contenedor.Placement.Middle
