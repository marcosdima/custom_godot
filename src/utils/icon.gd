@tool
extends Ente
class_name Icon

enum DefaultIcons {
	Bottle,
	Clear,
	Document,
	Football,
	Glasses,
	Headphones,
	Key,
	List,
	Lock,
	Mate,
	Money,
	Notebook,
	Play,
	Plus,
	Square,
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
@export var default: DefaultIcons = DefaultIcons.Play:
	set(value):
		default = value
		self.set_texture()

var rotate = 0

const icons_path = "res://static/images/icons"

static func exists(icon: DefaultIcons) -> bool:
	return FileAccess.file_exists(Icon.get_icon_path(icon))


static func get_icon_path(icon: DefaultIcons) -> String:
	return icons_path + "/" + DefaultIcons.find_key(icon).to_lower() + ".svg"


func _init(def: DefaultIcons = DefaultIcons.Play) -> void:
	super()
	default = def


func set_texture() -> void:
	if Icon.exists(default):
		var path = icons_path + "/" + DefaultIcons.find_key(default).to_lower() + ".svg"
		icon_texture = load(path)


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


func set_default(def: DefaultIcons) -> void:
	default = def
	self.handle_resize()
