extends Control

const Channels : Array[String] = ["Main", "Ambient", "Effects", "Music", "Weather", "Voice"]

var MainMenu : CenterContainer
var GameMenu : CenterContainer
var ConfigMenu : CenterContainer
var SaveFileList : ItemList

var Main : float = 0.0
var Ambient : float = 0.0
var Effects : float = 0.0
var Music : float = 0.0
var Weather : float = 0.0
var Voice : float = 0.0

func adjust_volume(channel:int, volume:float)->void:
	AudioServer.set_bus_volume_db(channel, volume)
	Manager.CfgData.set_value("Audio", Channels[channel], volume)

func toggle_menu(menu:CenterContainer)->void:
	if menu.visible:
		menu.hide()
	else:
		menu.show()

func _ready():
	MainMenu = $MenuMain
	ConfigMenu = $MenuConfig
	GameMenu = $MenuGame
	SaveFileList = $MenuGame/vbGameListing/listSaveGames

###
# Main Menu
###
func _on_btn_game_pressed():
	toggle_menu(MainMenu)
	toggle_menu(GameMenu)

func _on_btn_config_pressed():
	toggle_menu(MainMenu)
	toggle_menu(ConfigMenu)

func _on_btn_exit_pressed():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

###
# Game Menu
###
func _on_menu_game_visibility_changed():
	if $MenuGame.visible:
	# get listing of save files
		var dir : DirAccess = DirAccess.open("user://")
		if DirAccess.get_open_error() == OK: # this should be OK=0=TRUE
			dir.change_dir("user://data/")
			dir.list_dir_begin()
			for file in dir.get_files():
				if file.ends_with("json"):
					$MenuGame/vbGameListing/listSaveGames.add_item(file)
			dir.list_dir_end()
		else:
			dir.make_dir("user://data/")

func _on_list_save_games_item_selected(index):
	if index != 0:
		Manager.SaveFile = SaveFileList.get_item_text(index)
	else:
		Manager.SaveFile = Manager.newGameFile

func _on_btn_game_back_pressed():
	toggle_menu(GameMenu)
	toggle_menu(MainMenu)

func _on_btn_game_load_pressed():
	pass # Replace with function body.

func _on_btn_game_erase_pressed():
	pass

###
# Configuration Menu
###
func _on_menu_config_visibility_changed():
	if $MenuConfig.visible:
		Main = Manager.CfgData.get_value("Audio", "Main", 0.0)
		Ambient = Manager.CfgData.get_value("Audio", "Ambient", 0.0)
		Effects = Manager.CfgData.get_value("Audio", "Effects", 0.0)
		Music = Manager.CfgData.get_value("Audio", "Music", 0.0)
		Weather = Manager.CfgData.get_value("Audio", "Weather", 0.0)
		Voice = Manager.CfgData.get_value("Audio", "Voice", 0.0)
		$MenuConfig/VBoxContainer/hbVolumeMain/hsVolMain.set_value_no_signal(Main)
		$MenuConfig/VBoxContainer/hbVolumeAmbient/hsVolAmbient.set_value_no_signal(Ambient)
		$MenuConfig/VBoxContainer/hbVolumeEffects/hsVolEffects.set_value_no_signal(Effects)
		$MenuConfig/VBoxContainer/hbVolumeMusic/hsVolMusic.set_value_no_signal(Music)
		$MenuConfig/VBoxContainer/hbVolumeVoice/hsVolVoice.set_value_no_signal(Voice)
		$MenuConfig/VBoxContainer/hbVolumeWeather/hsVolWeather.set_value_no_signal(Weather)

func _on_hs_vol_main_value_changed(value):
	Main = value
	adjust_volume(0, value)

func _on_hs_vol_ambient_value_changed(value):
	Ambient = value
	adjust_volume(1, value)

func _on_hs_vol_effects_value_changed(value):
	Effects = value
	adjust_volume(2, value)

func _on_hs_vol_music_value_changed(value):
	Music = value
	adjust_volume(3, value)

func _on_hs_vol_voice_value_changed(value):
	Voice = value
	adjust_volume(4, value)

func _on_hs_vol_weather_value_changed(value):
	Weather = value
	adjust_volume(5, value)

func _on_btn_cfg_close_pressed():
	Manager.SaveConfig()
	toggle_menu(ConfigMenu)
	toggle_menu(MainMenu)
