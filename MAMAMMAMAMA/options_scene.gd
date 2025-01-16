extends Control

@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX BUS")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("MUSIC BUS")
@onready var sfxslider = %sfxslider
@onready var musicslider = %musicslider
@onready var mapopacityslider = %mapopacityslider
var userOptions: OptionsResource
func _ready() -> void:
	userOptions = OptionsResource.load_or_create()
	if sfxslider:
		sfxslider.value =userOptions.sfx_audio_level
	if musicslider:
		musicslider.value =userOptions.music_audio_level
	if mapopacityslider:
		mapopacityslider.value =userOptions.map_opacity_level
		
func _on_back_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MenuScene.tscn")



func _on_sfxslider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_ID, value < 0.5)
	if userOptions:
		userOptions.sfx_audio_level = value
		userOptions.save()


func _on_musicslider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, value < 0.5)
	if userOptions:
		userOptions.music_audio_level = value
		userOptions.save()


func _on_mapopacityslider_value_changed(value: float) -> void:
	if userOptions:
		userOptions.map_opacity_level = value
		userOptions.save()
