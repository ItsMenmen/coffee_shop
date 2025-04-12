extends Node2D

@onready var sprite = $Sprite2D
@onready var entry_point = get_node("/root/café/EntryPoint")
@onready var service_point = get_node("/root/café/ServicePoint")

@export var texture: Texture  # Texture du client à afficher
@export var visual_scale: Vector2 = Vector2(0.15, 0.15)  # Permet de définir la taille dans l’inspecteur

var speed := 100.0
var moving := true
var client_scene := preload("res://scene/Client.tscn")  # Le client interactif à instancier

func _ready():
	sprite.global_position = entry_point.global_position
	sprite.texture = texture
	sprite.scale = visual_scale  # 🔥 applique la taille dès le début

	#sprite.scale = Vector2(0.25, 0.25)
	print("Départ client à :", sprite.global_position)

func _process(delta):
	if moving:
		var direction = (service_point.global_position - sprite.global_position).normalized()
		var distance = sprite.global_position.distance_to(service_point.global_position)

		if distance > 5.0:
			sprite.global_position += direction * speed * delta
		else:
			moving = false
			print("Client arrivé au comptoir !")
			replace_with_interactive_client()

func replace_with_interactive_client():
	var new_client = client_scene.instantiate()
	new_client.global_position = service_point.global_position
	get_parent().add_child(new_client)

	# Transmet la texture à la scène Client si elle a la méthode
	if new_client.has_method("set_texture"):
		new_client.set_texture(texture)

	queue_free()
