class_name DialogueVoicePlayer
extends AudioStreamPlayer
	
var _random_number_gen := RandomNumberGenerator.new()

func _ready():
	_random_number_gen.randomize()
	
func play_play(from_position := 0.0):
	pitch_scale = _random_number_gen.randf_range(0.85,1.15)
	play(from_position)
