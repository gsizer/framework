extends Node

enum Dice { D4=4, D6=6, D8=8, D10=10, D12=12, D20=20, D100=100 }

const sysData : String = "res://data"
const cfgDefPref : String = "res://data/prefs.cfg"
const usrData : String = "user://data"
const cfgUserPref : String = "user://data/prefs.cfg"
const newGameFile : String = "res://data/new_game.tscn"

var SaveFile : String = "res://data/default.tscn"
var CfgData := ConfigFile.new()
var _loaded_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	# test for resource data directory and create if not found
	var dir := DirAccess.open(sysData)
	if not dir.dir_exists(sysData) :
		dir.make_dir(sysData)
	# load or reset configuration
	CfgData.clear()
	var err = CfgData.load(cfgDefPref)
	if  err != OK:
		print_debug("Config Error:", err)
		set_config_defaults()
	# test for user data directory and create if not found
	if not dir.dir_exists(usrData) :
		dir.make_dir(usrData)
	# load user preferences overwriting and appending to defaults
	dir.change_dir(usrData)
	if dir.file_exists(cfgUserPref):
		print_debug("Config Read User")
		CfgData.load(cfgUserPref)

func set_config_defaults()->void:
	print_debug("Setting default configuration.")
	CfgData.set_value("Audio","Ambient",0.0)
	CfgData.set_value("Audio","Effects",0.0)
	CfgData.set_value("Audio","Main",0.0)
	CfgData.set_value("Audio","Music",0.0)
	CfgData.set_value("Audio","Weather",0.0)
	CfgData.set_value("Audio","Voice",0.0)
	CfgData.save(cfgDefPref)
	CfgData.save(cfgUserPref)

func SaveConfig()->void:
	print_debug("Write Config:")
	for section in CfgData.get_sections():
		for key in CfgData.get_section_keys(section):
			print_debug( section, ":", key, ":", CfgData.get_value(section, key) )
	CfgData.save(cfgUserPref)

func Report(from:Object, message:String)->void:
	print(from.to_string())
	print(message)

func Roll( count:int, die:Dice )->Array[int]:
	var total : int = 0
	var results : Array[int] = []
	results.clear()
	for d in count:
		results.append( randi_range(1, die) )
		total += results[d]
	results.append(total)
	return results

func LoadProgress()->void:
	ResourceLoader.load_threaded_request(Manager.SaveFile)
	_loaded_scene = ResourceLoader.load_threaded_get(Manager.SaveFile)
	var new_game = _loaded_scene.instantiate()
	add_child(new_game)
