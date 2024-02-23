extends Resource
class_name ClientResource

@export var client_id: int
#checkbox to mark if this client has come up so far this run
@export var read_this_run: bool
@export var client_name: String
@export var client_subtitle: String


#Resource Dropdown List
@export_enum('Validation', 'Practical', 'Spiritual') var reason : int
@export_enum('Moral', 'Business/Politics', 'Love', 'Natural') var theme : int

@export var question: String 

@export var reaction_positive: String
@export var reaction_negative: String
@export var reaction_neutral: String
@export var portrait_path: String
