class_name DialogueManager
extends Node
	
var DIALOGUE_SCENE = get_parent()
	
#@onready var opacity_tween = get_node("OpacityTween") as Tween
	
signal message_requested()
signal message_completed()
  
signal finished()
	
var _messages := []
var _active_dialogue_offset := 0
var _is_active := false
var cur_dialogue_instance: Dialogue
	
func show_messages(message_list: Array, position: Vector2):
	
	# Only allow triggering if its not currently showing something
	if _is_active:
		return
	_is_active = true
	
	_messages = message_list
	_active_dialogue_offset = 0
	
	var _dialogue = DIALOGUE_SCENE.instance()
	_dialogue.connect("message_completed", self, "_on_message_completed")
	get_tree().get_root().add_child(_dialogue)
	
	cur_dialogue_instance = _dialogue
	
	_show_current()
	
func _show_current():
	emit_signal("message_requested")
	var _msg := _messages[_active_dialogue_offset] as String
	cur_dialogue_instance.update_message(_msg)
	
# File: DialogueManager.gd
	
func _hide():
	cur_dialogue_instance.disconnect("message_completed", _on_message_completed())
	cur_dialogue_instance.queue_free()
	cur_dialogue_instance = null
	_is_active = false
	emit_signal("finished")

func _on_message_completed():
	emit_signal("message_completed")
