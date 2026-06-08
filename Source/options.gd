class_name Options
extends Resource
enum OptionNames{
	SIMPLE_DESC = 0,
	AUTOSAVE_ENTRY = 1,
	AUTOSAVE_EXIT = 2,
}
@export var option_list = {
	OptionNames.SIMPLE_DESC: false,
	OptionNames.AUTOSAVE_ENTRY: true,
	OptionNames.AUTOSAVE_EXIT: true
}
func get_option(key):
	return option_list.get(key,null)
