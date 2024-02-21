extends Resource
class_name EventResource

@export var event_id: int
@export_enum('Positive', 'Neutral', 'Negative') var event_alliance: String
@export var event_text: String
@export var karma_change: int
@export var gold_change: int
@export var rep_change: int
@export var karma_gain: bool
@export var gold_gain: bool
@export var rep_gain: bool
