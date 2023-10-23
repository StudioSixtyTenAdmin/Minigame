extends Node2D

@export var client_resource : ClientResource
@onready var client_id = get_parent().get_parent().get_parent()._get_client_id()


var client_path 



# Called when the node enters the scene tree for the first time.
func _ready():
	client_path = 'res://assets/client_resources/client_'+str(client_id)+'.tres'
	client_resource = load(client_path)
	print('Client Ready FIrst: ',Time.get_ticks_msec(),'client_id: ',client_id)
	var portrait_path = client_resource.portrait_path
	var client_portrait = Image.load_from_file(portrait_path)
	var client_name = client_resource.client_name
	#var intro_text = client_resource.intro_text
	var reaction_a = client_resource.reaction_negative
	var reaction_b = client_resource.reaction_positive
	get_child(0).texture = ImageTexture.create_from_image(client_portrait)
