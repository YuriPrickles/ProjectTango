class_name AudioEngine
extends Node

const SAMPLE_RATE := 44100.0

var voices := {}
var channel_voice_map := {}
var default_voice: Voice
var program_overrides := false

func _init():
	default_voice = Voice.new()

func set_channel_voice(channel: int, voice: Voice):
	channel_voice_map[channel] = voice

func get_voice_for_channel(channel: int) -> Voice:
	return channel_voice_map.get(channel, default_voice)

func set_program(channel: int, program: int):
	if program_overrides or channel_voice_map.has(channel):
		return
	var voice = Voice.new()
	voice.waveform = _waveform_for_program(program)
	channel_voice_map[channel] = voice

func reset():
	voices.clear()
	channel_voice_map.clear()
	program_overrides = false

func load_track(track: MidiTrack):
	for channel in track.channel_voices:
		var ch: int = int(channel)
		var voice = track.channel_voices[channel] as Voice
		if voice:
			channel_voice_map[ch] = voice
	program_overrides = track.program_overrides

func note_on(channel: int, note: int, velocity: int):
	if velocity == 0:
		note_off(channel, note)
		return

	var voice = get_voice_for_channel(channel)
	var vi = VoiceInstance.new(note, velocity, voice)
	voices["%d:%d" % [channel, note]] = vi

func note_off(channel: int, note: int):
	var key = "%d:%d" % [channel, note]
	var vi = voices.get(key) as VoiceInstance
	if vi:
		vi.release()

func generate_audio(playback: AudioStreamGeneratorPlayback):
	var frames = playback.get_frames_available()
	var dt = 1.0 / SAMPLE_RATE

	for _i in range(frames):
		var sample := 0.0
		var count := 0
		var dead := []

		for key in voices:
			var vi = voices[key] as VoiceInstance
			var out = vi.process(dt)
			if vi.is_active():
				sample += out
				count += 1
			else:
				dead.append(key)

		for key in dead:
			voices.erase(key)

		if count > 0:
			sample /= count

		sample = clamp(sample, -1.0, 1.0)
		playback.push_frame(Vector2(sample, sample))

static func _waveform_for_program(program: int) -> Voice.Waveform:
	if program < 8:
		return Voice.Waveform.TRIANGLE
	elif program < 32:
		return Voice.Waveform.SQUARE
	elif program < 64:
		return Voice.Waveform.TRIANGLE
	else:
		return Voice.Waveform.SAW
