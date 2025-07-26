@tool
extends Ente
class_name Icon

enum DefaultIcons {
	AirPods,
	Bottle,
	Clear,
	Document,
	Football,
	Glasses,
	Key,
	List,
	Lock,
	Mate,
	Money,
	Notebook,
	Play,
	Plus,
	TurnOff,
	Umbrella,
	Wallet,
}

@export var icon_texture: CompressedTexture2D:
	get():
		if !icon_texture:
			self.set_texture()
		return icon_texture
@export var color: Color
@export var default: DefaultIcons:
	set(value):
		default = value
		self.set_texture()

var rotate = 0

const icons_path = "res://static/images/icons"

func set_texture() -> void:
	self.icon_texture = load(
		self.icons_path
		+ "/"
		+ DefaultIcons.find_key(self.default).to_lower()
		+ ".svg"
	)


func _draw() -> void:
	super()
	
	var contenedor_size = self.get_area().size
	var texture_size = self.icon_texture.get_size()
	
	var scale_aux = min(contenedor_size.x / texture_size.x, contenedor_size.y / texture_size.y)
	var final_size = texture_size * scale_aux * 0.7
	var position_aux = (contenedor_size - final_size) / 2
	
	var angle = deg_to_rad(self.rotate)
	var center = position_aux + final_size / 2  
	
	draw_set_transform(center, angle, Vector2(1, 1))
	draw_texture_rect(self.icon_texture, Rect2(-final_size / 2, final_size), false, self.color)
	draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)
