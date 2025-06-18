@tool
class_name Icon
extends Ente

enum DefaultIcons {
	Wallet,
	Key,
	Glasses,
	Document,
	Play,
	Umbrella,
	Money,
	Bottle,
	AirPods,
	Mate,
	Notebook,
	Lock,
	TurnOff,
	Football,
	List,
	Nothing,
	Plus,
}

@export var icon_texture: CompressedTexture2D
@export var icon_color: Color
@export var default: DefaultIcons = DefaultIcons.Nothing

var rotate = 0

const icons_path = "res://static/images/icons"

## [OVERWRITTEN]
func handle_resize() -> void:
	super()
	self.set_texture()


func set_texture() -> void:
	if self.default != DefaultIcons.Nothing:
		self.icon_texture = load(
			self.icons_path
			+ "/"
			+ DefaultIcons.find_key(self.default).to_lower()
			+ ".svg"
		)


func _draw() -> void:
	super()
	
	var contenedor_size = self.get_area().size
	var texture_size = icon_texture.get_size()
	
	var scale_aux = min(contenedor_size.x / texture_size.x, contenedor_size.y / texture_size.y)
	var final_size = texture_size * scale_aux * 0.7
	var position_aux = (contenedor_size - final_size) / 2
	
	var angle = deg_to_rad(self.rotate)
	var center = position_aux + final_size / 2  
	
	draw_set_transform(center, angle, Vector2(1, 1))
	draw_texture_rect(self.icon_texture, Rect2(-final_size / 2, final_size), false, self.icon_color)
	draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)


static func exists(k: String) -> bool:
	return FileAccess.file_exists(icons_path + '/' + k.to_lower() + ".svg")
