extends Node

const SAMPLE_RATE := 44100.0

@export var autoplay: bool = true
@export var midi_track: MidiTrack = null
@export var volume: float = 1.0

var audio_engine: AudioEngine
var player: AudioStreamPlayer
var playback: AudioStreamGeneratorPlayback
var events := []
var event_index := 0
var song_time := 0.0

func _ready():
	audio_engine = AudioEngine.new()
	add_child(audio_engine)

	var stream := AudioStreamGenerator.new()
	stream.mix_rate = SAMPLE_RATE
	stream.buffer_length = 0.1

	player = AudioStreamPlayer.new()
	player.stream = stream
	add_child(player)

	if autoplay and midi_track:
		play()

func play():
	if not midi_track or midi_track.midi_file.is_empty():
		push_error("No MidiTrack configured")
		return

	audio_engine.reset()
	audio_engine.load_track(midi_track)

	events = MidiParser.load(midi_track.midi_file)
	event_index = 0
	song_time = 0.0

	player.volume_db = linear_to_db(volume)
	player.play()
	playback = player.get_stream_playback()

func stop():
	player.stop()
	events.clear()
	event_index = 0
	song_time = 0.0

func _process(delta):
	if events.is_empty() or not playback:
		return

	song_time += delta

	while event_index < events.size():
		var event = events[event_index]
		if event.time > song_time:
			break

		match event.type:
			"note_on":
				audio_engine.note_on(event.channel, event.note, event.velocity)
			"note_off":
				audio_engine.note_off(event.channel, event.note)
			"program":
				audio_engine.set_program(event.channel, event.program)

		event_index += 1

	audio_engine.generate_audio(playback)
