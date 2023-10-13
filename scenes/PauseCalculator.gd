class_name PauseCalculator
extends Node

const PAUSE_PATTERN := "({p=\\d([.]\\d+)?[}])"

const FLOAT_PATTERN := "\\d+\\.\\d+"
const BBCODE_I_PATTERN := "\\[(?!\\/)(.*?)\\]"
const BBCODE_E_PATTERN := "\\[\\/(.*?)\\]"

const CUSTOM_TAG_PATTERN := "({(.*?)})"

var _pause_regex := RegEx.new()
var _pauses := []    
signal pause_requested(duration)



var _float_regex := RegEx.new()
var _bbcode_i_regex := RegEx.new()
var _bbcode_e_regex := RegEx.new()
var _custom_tag_regex := RegEx.new()



func _ready() -> void:
	_pause_regex.compile(PAUSE_PATTERN)
	
	_float_regex.compile(FLOAT_PATTERN)
	_bbcode_i_regex.compile(BBCODE_I_PATTERN)
	_bbcode_e_regex.compile(BBCODE_E_PATTERN)
	_custom_tag_regex.compile(CUSTOM_TAG_PATTERN)

func extract_pauses_from_string(source_string: String): 
	_pauses = [] 
	_find_pauses(source_string)
	return _extract_tags(source_string)
	
func _find_pauses(source_string: String):
	var _found_pauses = _pause_regex.search_all(source_string)
	for _result in _found_pauses:
		
		var _tag_string = _result.get_string() as String
		var _tag_position = _result.get_start() as int
		
		var _pause = Pause.new(_tag_position, _tag_string)
		_pauses.append(_pause)
	
func _extract_tags(source_string: String):
	var _custom_regex = RegEx.new()
	_custom_regex.compile("({(.*?)})")
	return _custom_regex.sub(source_string, "", true)

func _check_at_position(pos: int):
	for _pause in _pauses:
		if _pause.pause_pos == pos:
			emit_signal("pause_requested", _pause.duration)
