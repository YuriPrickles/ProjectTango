class_name VoiceInstance
extends RefCounted

enum EnvState { IDLE, ATTACK, DECAY, SUSTAIN, RELEASE }

var note: int
var frequency: float
var velocity: float
var phase := 0.0
var voice: Voice

var env_state := EnvState.IDLE
var env_level := 0.0
var env_time := 0.0
var release_start_level := 0.0


var filter_state := 0.0
var modulators: Array[VoiceInstance]

func _init(n: int, vel: int, v: Voice):
	note = n
	velocity = vel / 127.0
	voice = v
	frequency = (440.0 * pow(2.0, (n - 69) / 12.0))
	env_state = EnvState.ATTACK
	if voice.modulation:
		for mod in voice.modulation:
			modulators.append(VoiceInstance.new(note,vel,mod))

func release():
	if env_state != EnvState.IDLE:
		release_start_level = env_level
		env_state = EnvState.RELEASE
		env_time = 0.0

func is_active() -> bool:
	return env_state != EnvState.IDLE

func process(dt: float) -> float:
	for mod in modulators:
		mod.process(dt)
	_update_envelope(dt)
	if env_state == EnvState.IDLE:
		return 0.0
	
	var out := _generate_waveform(phase)
	out *= velocity * voice.volume
	out = _apply_filter(out)
	out *= env_level

	_advance_phase()
	return out

func _update_envelope(dt: float):
	env_time += dt

	match env_state:
		EnvState.ATTACK:
			if env_time >= voice.attack:
				env_level = 1.0
				env_state = EnvState.DECAY
				env_time = 0.0
			else:
				env_level = env_time / max(voice.attack, 0.001)

		EnvState.DECAY:
			if env_time >= voice.decay:
				env_level = voice.sustain
				env_state = EnvState.SUSTAIN
			else:
				var t = env_time / max(voice.decay, 0.001)
				env_level = 1.0 - (1.0 - voice.sustain) * t

		EnvState.SUSTAIN:
			env_level = voice.sustain

		EnvState.RELEASE:
			if env_time >= voice.release:
				env_level = 0.0
				env_state = EnvState.IDLE
			else:
				var t = env_time / max(voice.release, 0.001)
				env_level = release_start_level * (1.0 - t)

func _generate_waveform(ph:float) -> float:
	var modulation = 0
	if modulators and not modulators.is_empty():
		for mod in modulators:
			modulation += mod._generate_waveform(phase)
	match voice.waveform:
		Voice.Waveform.SINE:
			return sin((ph * voice.frequency_mult) + modulation) * voice.volume
		Voice.Waveform.SQUARE:
			return 1.0 if sin(ph * voice.frequency_mult + modulation) >= 0.0 else -1.0 * voice.volume
		Voice.Waveform.TRIANGLE:
			return (asin(sin(ph * voice.frequency_mult)+ modulation ) * (2.0 / PI)) * voice.volume
		Voice.Waveform.SAW:
			return (((ph * voice.frequency_mult / PI) + modulation) - 1.0) * voice.volume
		Voice.Waveform.NOISE:
			return (randf_range(-1,1) * voice.frequency_mult + modulation) * voice.volume
	return 0.0

func _apply_filter(input: float) -> float:
	if voice.filter_cutoff >= 22000.0:
		return input

	var cutoff_angle = TAU * voice.filter_cutoff / 44100.0
	cutoff_angle = min(cutoff_angle, 0.9 * PI)
	var a = cutoff_angle / (1.0 + cutoff_angle)
	filter_state = a * input + (1.0 - a) * filter_state
	return filter_state

func _advance_phase():
	phase += TAU * frequency / 44100.0
	if phase >= TAU:
		phase -= TAU
