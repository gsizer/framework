extends Node

const sysData : String = "res://data"
const usrData : String = "user://data"
const cfgDefaults : String = "res://data/defaults.cfg"
const cfgUserPref : String = "user://data/prefs.cfg"
const SaveExt : String = "json"

var CfgData := ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# test for resource data directory and create if not found
	var dir := DirAccess.open("res://")
	if not dir.dir_exists(sysData) : dir.make_dir(sysData)
	# reset configuration
	CfgData.clear()
	# load or set defaults
	if not CfgData.load(cfgDefaults) : set_config_defaults()
	# test for user data directory and create if not found
	if not dir.dir_exists(usrData) : dir.make_dir(usrData)
	# load user preferences overwriting and appending to defaults
	CfgData.load(cfgUserPref)

func set_config_defaults()->void:
	CfgData.set_value("Audio","Ambient",0.0)
	CfgData.set_value("Audio","Effects",0.0)
	CfgData.set_value("Audio","Main",0.0)
	CfgData.set_value("Audio","Music",0.0)
	CfgData.set_value("Audio","Weather",0.0)
	CfgData.set_value("Audio","Voice",0.0)
	print_debug(CfgData)
