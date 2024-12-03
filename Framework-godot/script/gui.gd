extends Control

enum { volMain=0, volAmbient=1, volEffects=2, volMusic=3, volWeather=4, volVoice=5 }
const Channels : Array[String] = ["Main", "Ambient", "Effects", "Music", "Weather", "Voice"]

@export var MainMenu : CenterContainer
@export var GameMenu : CenterContainer
@export var ConfigMenu : CenterContainer
@export var SaveFileList : ItemList
@export var hsMain : HSlider
@export var hsAmbient : HSlider
@export var hsEffects : HSlider
@export var hsMusic : HSlider
@export var hsVoice : HSlider
@export var hsWeather : HSlider
@export var LoadingScreen : CenterContainer
@export var pbLoading : ProgressBar

func adjust_volume(channel:int, volume:float)->void:
	AudioServer.set_bus_volume_db(channel, volume)
	Manager.CfgData.set_value("Audio", Channels[channel], volume)
	var _message : String = "Config set: Audio:{c}:{v}".format(
		{"c":Channels[channel], "v":volume})
	Manager.Report(self, _message)

func toggle_menu(menu:CenterContainer)->void:
	if menu.visible:
		menu.hide()
	else:
		menu.show()

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
	if MainMenu.visible:
	# get listing of save files
		var dir : DirAccess = DirAccess.open(Manager.usrData)
		if DirAccess.get_open_error() == OK: # this should be OK=0=TRUE
			dir.list_dir_begin()
			for file in dir.get_files():
				if file.ends_with("json"):
					SaveFileList.add_item(file)
			dir.list_dir_end()
		else:
			dir.make_dir(Manager.usrData)

func _on_list_save_games_item_selected(index):
	if index != 0:
		Manager.SaveFile = SaveFileList.get_item_text(index)
	else:
		Manager.SaveFile = Manager.newGameFile

func _on_btn_game_back_pressed():
	toggle_menu(GameMenu)
	toggle_menu(MainMenu)

func _on_btn_game_load_pressed():
	Manager.Report(self, "Load Save:"+Manager.SaveFile)
	GameMenu.hide()
	LoadingScreen.show()
	Manager.LoadProgress()
	LoadingScreen.hide()

func _on_btn_game_erase_pressed():
	if Manager.SaveFile == Manager.newGameFile:
		Manager.Report(self, "Delete Fail:"+Manager.SaveFile)
	else:
		Manager.Report(self, "Delete Save:"+Manager.SaveFile)
		# open user save folder
		var d : DirAccess = DirAccess.open(Manager.usrData)
		# test for save file and delete
		if d.file_exists(Manager.SaveFile):
			d.remove(Manager.SaveFile)
		# reset savefile to newgame
		Manager.SaveFile = Manager.newGameFile

###
# Configuration Menu
###
func _on_menu_config_visibility_changed():
	# Menu becomes visible, update sliders from config values
	if  MainMenu.visible:
		hsMain.value = Manager.CfgData.get_value("Audio", "Main", -10.0)
		hsAmbient.value = Manager.CfgData.get_value("Audio", "Ambient", -60.0)
		hsEffects.value = Manager.CfgData.get_value("Audio", "Effects", -50.0)
		hsMusic.value = Manager.CfgData.get_value("Audio", "Music", -30.0)
		hsVoice.value = Manager.CfgData.get_value("Audio", "Weather", -20.0)
		hsWeather.value = Manager.CfgData.get_value("Audio", "Voice", -40.0)

func _on_hs_vol_main_drag_ended(value_changed):
	if value_changed : adjust_volume(volMain, hsMain.value)

func _on_hs_vol_ambient_drag_ended(value_changed):
	if value_changed : adjust_volume(volAmbient, hsAmbient.value)

func _on_hs_vol_effects_drag_ended(value_changed):
	if value_changed : adjust_volume(volEffects, hsEffects.value)

func _on_hs_vol_music_drag_ended(value_changed):
	if value_changed : adjust_volume(volMusic, hsMusic.value)

func _on_hs_vol_voice_drag_ended(value_changed):
	if value_changed : adjust_volume(volVoice, hsVoice.value)

func _on_hs_vol_weather_drag_ended(value_changed):
	if value_changed : adjust_volume(volWeather, hsWeather.value)

func _on_btn_cfg_close_pressed():
	Manager.SaveConfig()
	toggle_menu(ConfigMenu)
	toggle_menu(MainMenu)

# first load into scene tree
func _ready():
	hsMain.value = Manager.CfgData.get_value("Audio", "Main", 0.0)
	hsAmbient.value = Manager.CfgData.get_value("Audio", "Ambient", -60.0)
	hsEffects.value = Manager.CfgData.get_value("Audio", "Effects", -30.0)
	hsMusic.value = Manager.CfgData.get_value("Audio", "Music", -40.0)
	hsVoice.value = Manager.CfgData.get_value("Audio", "Weather", -20.0)
	hsWeather.value = Manager.CfgData.get_value("Audio", "Voice", -50.0)
	GameMenu.hide()
	ConfigMenu.hide()
	pbLoading.value = 0
	LoadingScreen.hide()
