extends Control

#True if they choose to progress to new location
signal location_move_choice

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_remain_pressed():
	location_move_choice.emit(false)


func _on_progress_pressed():
		location_move_choice.emit(true)
