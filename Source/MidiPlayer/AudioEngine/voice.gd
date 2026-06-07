class_name Voice
extends Resource

enum Waveform {
	SINE,
	SQUARE,
	TRIANGLE,
	SAW,
	NOISE
}

@export var voice_name: String = "Voice"
@export var waveform: Waveform = Waveform.SINE
@export var volume: float = 1.0
@export var frequency_mult: float = 1
@export var modulation:Array[Voice]

@export_group("ADSR and also filter i guess")
@export var attack: float = 0.002
@export var decay: float = 0.1
@export var sustain: float = 0.25
@export var release: float = 0.15

@export var filter_cutoff: float = 20000.0
@export var filter_resonance: float = 0.0
