@tool
extends Ente
class_name Icon

enum DefaultIcons {
	Bottle,
	Clear,
	Document,
	Dot,
	Football,
	Glasses,
	Headphones,
	Key,
	List,
	Lock,
	Mate,
	Money,
	Notebook,
	Pen,
	Play,
	Plus,
	Square,
	TurnOff,
	Umbrella,
	Wallet,
}

@export var color: Color:
	set(value):
		color = value
		if sprite:
			sprite.modulate = value
		self.queue_redraw()
@export var default: DefaultIcons = DefaultIcons.Play:
	set(value):
		default = value
		self.set_texture()

var rotate: float
var scale_factor: float
var icon_texture: Texture2D
var sprite: Sprite2D
const icons_path = "res://static/images/icons/"
const alternative_icons_path = "res://.godot/imported/"

static func exists(icon: DefaultIcons) -> bool:
	return FileAccess.file_exists(Icon.get_icon_path(icon))


static func get_icon_path(icon: DefaultIcons) -> String:
	var key = DefaultIcons.find_key(icon).to_lower()
	
	if Alambre.is_computer():
		return icons_path + key + '.svg'
	
	var dir = DirAccess.open(alternative_icons_path)
	var target = ""
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() and file_name.begins_with(key):
				target = alternative_icons_path + file_name
			file_name = dir.get_next()
		dir.list_dir_end()
	
	return target


func _init(
	def: DefaultIcons = DefaultIcons.Play,
	scale_factor_: float = 0.7,
	rotate_: float = 0,
) -> void:
	super()
	
	default = def
	rotate = rotate_
	scale_factor = scale_factor_
	self.set_texture()
	
	## Creates a Sprite2D
	sprite = Sprite2D.new()
	sprite.texture = icon_texture
	self.resize.connect(adapt_sprite)
	self.add_child(sprite)


func set_texture() -> void:
	if Icon.exists(default):
		var path = Icon.get_icon_path(default)
		icon_texture = load(path)


func set_default(def: DefaultIcons) -> void:
	default = def
	self.set_texture()
	sprite.texture = icon_texture
	self.adapt_sprite()


func adapt_sprite() -> void:
	if !sprite.texture:
		return
	sprite.modulate = color
	
	# Calculate proportional scale
	var texture_size = sprite.texture.get_size()
	var scale_aux = min(size.x / texture_size.x, size.y / texture_size.y)
	var final_size = texture_size * scale_aux * 0.7
	
	# Set sprite scale
	sprite.scale = final_size / texture_size
	
	# Center the sprite inside the container
	sprite.position = (size - final_size) / 2 + final_size / 2
	
	# Optional rotation
	sprite.rotation = deg_to_rad(rotate)
