extends Resource
class_name OptionsResource

@export_range(0,1,0.05) var music_audio_level: float = 1.0
@export_range(0,1,0.05) var sfx_audio_level: float = 1.0
@export_range(0,1,0.05) var map_opacity_level: float = 1.0

func save()->void:
	ResourceSaver.save(self, "user://user_options.tres")
	
static func load_or_create() -> OptionsResource:
	var res: OptionsResource = load("user://user_options.tres") as OptionsResource
	if !res:
		res = OptionsResource.new()
		
	return res
