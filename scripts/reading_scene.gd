extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Background.set_size(DisplayServer.window_get_size())
	

func _on_option_a_pressed():
	$AspectRatioContainer2/card._new_card()


func _on_option_b_pressed():
	$AspectRatioContainer2/card._new_card()
