extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Background.set_size(DisplayServer.window_get_size())

func _new_card():
	$AspectRatioContainer2/card._new_card()

