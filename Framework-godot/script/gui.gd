extends Control

const Channels : Array[String] = ["Main", "Ambient", "Effects", "Music", "Weather", "Voice"]

var Main : float = 0.0
var Ambient : float = 0.0
var Effects : float = 0.0
var Music : float = 0.0
var Weather : float = 0.0
var Voice : float = 0.0

###
# Main Menu
###
func _on_btn_game_pressed():
	toggle_menu($MenuMain)
	toggle_menu($MenuGame)

func _on_btn_config_pressed():
	toggle_menu($MenuMain)
	toggle_menu($MenuConfig)

func _on_btn_exit_pressed():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func toggle_menu(menu:CenterContainer)->void:
	if menu.visible:
		menu.hide()
	else:
		menu.show()

###
# Game Menu
###
func _on_menu_game_visibility_changed():
	if $MenuGame.visible:
	# get listing of save files
		var dir := DirAccess.open("user://data")
		if not dir.get_open_error():
			print_debug("User data directory:", dir.get_open_error())
		for file in dir.get_files() : $MenuGame/vbGameListing/listSaveGames.add_item(file)

###
# Configuration Menu
###
func _on_menu_config_visibility_changed():
	Main = Manager.CfgData.get_value("Audio", "Main", 0.0)
	Ambient = Manager.CfgData.get_value("Audio", "Ambient", 0.0)
	Effects = Manager.CfgData.get_value("Audio", "Effects", 0.0)
	Music = Manager.CfgData.get_value("Audio", "Music", 0.0)
	Weather = Manager.CfgData.get_value("Audio", "Weather", 0.0)
	Voice = Manager.CfgData.get_value("Audio", "Voice", 0.0)

func _on_hs_vol_main_value_changed(value):
	Main = value
	AudioServer.set_bus_volume_db(0, value)
	Manager.CfgData.set_value("Audio", "Main", value)

func _on_hs_vol_ambient_value_changed(value):
	Ambient = value
	AudioServer.set_bus_volume_db(1, value)
	Manager.CfgData.set_value("Audio", "Ambient", value)

func _on_hs_vol_effects_value_changed(value):
	Effects = value
	AudioServer.set_bus_volume_db(2, value)
	Manager.CfgData.set_value("Audio", "Effects", value)

func _on_hs_vol_music_value_changed(value):
	Music = value
	AudioServer.set_bus_volume_db(3, value)
	Manager.CfgData.set_value("Audio", "Music", value)

func _on_hs_vol_voice_value_changed(value):
	Voice = value
	AudioServer.set_bus_volume_db(4, value)
	Manager.CfgData.set_value("Audio", "Voice", value)

func _on_hs_vol_weather_value_changed(value):
	Weather = value
	AudioServer.set_bus_volume_db(5, value)
	Manager.CfgData.set_value("Audio", "Weather", value)

func _on_btn_cfg_close_pressed():
	toggle_menu($MenuConfig)
	toggle_menu($MenuMain)
