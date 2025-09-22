extends EnteResource
class_name ComponentResourse

@export_group("Component", "")
@export var color: Color = Color.BLACK
@export_subgroup("Placement", "") ## This should go with ContenedorResourse... But I don't think that will be needed.
@export var horizontal: Contenedor.Placement = Contenedor.Placement.Middle
@export var vertical: Contenedor.Placement = Contenedor.Placement.Middle
@export_group("", "")

func apply(ente: Ente):
	super(ente)
	
	var component = ente as Text
	if !component:
		printerr("Expected Component but received: ", ente)
		return
	
	component.color = color
	component.placement_axis_x = horizontal
	component.placement_axis_y = vertical
