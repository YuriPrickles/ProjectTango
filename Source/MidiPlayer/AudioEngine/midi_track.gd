@tool
class_name MidiTrack
extends Resource

@export_file_path("*.mid") var midi_file: String = "" : set = _set_midi_file
@export var track_name: String = ""

@export var channel_voices: Dictionary[String, Voice] = {}
@export var program_overrides: bool = false

@export_custom(PropertyHint.PROPERTY_HINT_ARRAY_TYPE, "String", PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_READ_ONLY) var missing_channels: Array = []

func _set_midi_file(path: String):
	midi_file = path

	if path.is_empty():
		track_name = ""
		return

	track_name = path.get_file().get_basename()

	var channels = MidiParser.discover_channels(path)
	missing_channels = []
	for channel in channels:
		if not channel_voices.has("%s" % channel):
			missing_channels.append(channel)
	notify_property_list_changed()
