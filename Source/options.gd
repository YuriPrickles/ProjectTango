class_name Options
extends Resource
enum OptionNames{
	SIMPLE_DESC = 0,
	AUTOSAVE_ENTRY = 1,
	AUTOSAVE_EXIT = 2,
	FULLSCREEN = 3,
}
@export var total_savescums = 0
@export var savescum_amount = 0
@export var record_savescum = false
@export var option_list = {
	OptionNames.SIMPLE_DESC: false,
	OptionNames.AUTOSAVE_ENTRY: true,
	OptionNames.AUTOSAVE_EXIT: true,
	OptionNames.FULLSCREEN: false,
}
func get_option(key):
	return option_list.get(key,null)
