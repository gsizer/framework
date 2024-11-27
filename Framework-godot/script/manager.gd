extends Node

const sysData : String = "res://data"
const cfgDefPref : String = "res://data/prefs.cfg"
const usrData : String = "user://data"
const cfgUserPref : String = "user://data/prefs.cfg"
const newGameFile : String = "res://scene/default.tscn"
var SaveFile : String = "res://data/default.tscn"

var CfgData := ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# test for resource data directory and create if not found
	var dir := DirAccess.open("res://")
	if not dir.dir_exists(sysData) :
		dir.make_dir(sysData)
	# load or reset configuration
	CfgData.clear()
	if not CfgData.load(cfgDefPref) :
		set_config_defaults()
	# test for user data directory and create if not found
	dir = DirAccess.open("user://")
	if not dir.dir_exists(usrData) :
		dir.make_dir(usrData)
	# load user preferences overwriting and appending to defaults
	if not CfgData.load(cfgUserPref) :
		set_config_defaults()

func set_config_defaults()->void:
	print_debug("Writing default configuration.")
	CfgData.set_value("Audio","Ambient",0.0)
	CfgData.set_value("Audio","Effects",0.0)
	CfgData.set_value("Audio","Main",0.0)
	CfgData.set_value("Audio","Music",0.0)
	CfgData.set_value("Audio","Weather",0.0)
	CfgData.set_value("Audio","Voice",0.0)

func SaveConfig()->void:
	CfgData.save(cfgUserPref)
