@tool
class_name Icon
extends Component

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
}

@export var icon_texture: CompressedTexture2D
@export var default: DefaultIcons = DefaultIcons.Nothing

const icons_path = "res://static/images/icons"

func _ready() -> void:
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
	if self.icon_texture:
		var contenedor_size = self.get_real_size()
		var texture_size = icon_texture.get_size()
		
		var scale_aux = min(contenedor_size.x / texture_size.x, contenedor_size.y / texture_size.y)
		
		var final_size = texture_size * scale_aux * 0.7
		var position_aux = Margin.start(self) / 2 + (contenedor_size - final_size) / 2
		
		draw_texture_rect(self.icon_texture, Rect2(position_aux, final_size), false, self.color)


'''╭─[ To-Overwrite methods ]───────────────────────────────────────────────────────────────╮'''
## This function will be called every time the editor is saved.
func editor_settings() -> void:
	super()
	self.set_texture()
