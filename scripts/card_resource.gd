extends Resource
class_name CardResource

@export var card_name: String
@export var upright_reading: String
@export var reversed_reading: String
@export var card_art_path: String
@export_enum('+', '-', '=') var upright_validation: int
@export_enum('+', '-', '=') var upright_practical: int
@export_enum('+', '-', '=') var upright_spiritual: int
@export_enum('+', '-', '=') var reversed_validation: int
@export_enum('+', '-', '=') var reversed_practical: int
@export_enum('+', '-', '=') var reversed_spiritual: int
