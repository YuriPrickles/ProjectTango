class_name MidiParser
extends RefCounted

static func load(path: String) -> Array:
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open MIDI file: ", path)
		return []

	var data = file.get_buffer(file.get_length())
	file.close()

	var pos := 0

	if get_string(data, pos, 4) != "MThd":
		push_error("Not a MIDI file")
		return []

	pos += 4
	var header_size = read_u32(data, pos)
	pos += 4
	var format = read_u16(data, pos)
	pos += 2
	var num_tracks = read_u16(data, pos)
	pos += 2
	var division = read_u16(data, pos)
	pos += 2
	pos += header_size - 6

	if format == 2:
		push_error("Type 2 MIDI files not supported")
		return []

	var events := []
	var tempo := 500000

	for _track in range(num_tracks):
		if get_string(data, pos, 4) != "MTrk":
			break

		pos += 4
		var track_size = read_u32(data, pos)
		pos += 4
		var track_end = pos + track_size
		var absolute_ticks := 0
		var running_status := 0

		while pos < track_end:
			var vlq = read_vlq(data, pos)
			absolute_ticks += vlq.value
			pos = vlq.pos

			var status = data[pos]

			if status < 0x80:
				status = running_status
			else:
				running_status = status
				pos += 1

			var seconds = absolute_ticks * tempo / float(max(division, 1)) / 1000000.0

			if status == 0xFF:
				var meta_type = data[pos]
				pos += 1
				var len_info = read_vlq(data, pos)
				var length = len_info.value
				pos = len_info.pos

				if meta_type == 0x51 and length == 3:
					tempo = (data[pos] << 16) | (data[pos + 1] << 8) | data[pos + 2]

				pos += length
				continue

			var event_type = status & 0xF0
			var channel = status & 0x0F

			match event_type:
				0x80:
					var note = data[pos]
					pos += 2
					events.append({
						"time": seconds, "type": "note_off",
						"channel": channel, "note": note
					})

				0x90:
					var note = data[pos]
					var velocity = data[pos + 1]
					pos += 2

					if velocity == 0:
						events.append({
							"time": seconds, "type": "note_off",
							"channel": channel, "note": note
						})
					else:
						events.append({
							"time": seconds, "type": "note_on",
							"channel": channel, "note": note,
							"velocity": velocity
						})

				0xC0:
					var program = data[pos]
					pos += 1
					events.append({
						"time": seconds, "type": "program",
						"channel": channel, "program": program
					})

				_:
					match event_type:
						0xA0, 0xB0, 0xE0:
							pos += 2
						0xD0:
							pos += 1
						_:
							pos += 1

	events.sort_custom(func(a, b): return a.time < b.time)
	print("Loaded ", events.size(), " MIDI events")
	return events


static func discover_channels(path: String) -> Array:
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		return []

	var data = file.get_buffer(file.get_length())
	file.close()

	var pos := 0

	if get_string(data, pos, 4) != "MThd":
		return []

	pos += 4
	var header_size = read_u32(data, pos)
	pos += 4
	var format = read_u16(data, pos)
	pos += 2
	var num_tracks = read_u16(data, pos)
	pos += 2
	var _division = read_u16(data, pos)
	pos += 2
	pos += header_size - 6

	if format == 2:
		return []

	var channels := {}

	for _track in range(num_tracks):
		if get_string(data, pos, 4) != "MTrk":
			break

		pos += 4
		var track_size = read_u32(data, pos)
		pos += 4
		var track_end = pos + track_size
		var running_status := 0

		while pos < track_end:
			var vlq = read_vlq(data, pos)
			pos = vlq.pos

			var status = data[pos]
			if status < 0x80:
				status = running_status
			else:
				running_status = status
				pos += 1

			if status == 0xFF:
				pos += 1
				var len_info = read_vlq(data, pos)
				pos = len_info.pos + len_info.value
				continue

			var event_type = status & 0xF0
			var channel = status & 0x0F

			match event_type:
				0x80, 0x90:
					channels[channel] = true
					pos += 2
				0xA0, 0xB0, 0xE0:
					pos += 2
				0xC0, 0xD0:
					pos += 1
				_:
					pos += 1

	return channels.keys()


static func read_u16(data: PackedByteArray, pos: int) -> int:
	return (data[pos] << 8) | data[pos + 1]

static func read_u32(data: PackedByteArray, pos: int) -> int:
	return ((data[pos] << 24) | (data[pos + 1] << 16)
			| (data[pos + 2] << 8) | data[pos + 3])

static func get_string(data: PackedByteArray, pos: int, length: int) -> String:
	var bytes := PackedByteArray()
	for i in range(length):
		bytes.append(data[pos + i])
	return bytes.get_string_from_ascii()

static func read_vlq(data: PackedByteArray, pos: int) -> Dictionary:
	var value := 0
	while true:
		var b = data[pos]
		pos += 1
		value = (value << 7) | (b & 0x7F)
		if (b & 0x80) == 0:
			break
	return {"value": value, "pos": pos}
