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
