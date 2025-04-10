extends Area2D

var player_near := false

@onready var interaction_panel = get_tree().current_scene.get_node("UI/InteractionPanel")

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	if body.name == "player":
		player_near = true
		interaction_panel.visible = true
		print("Le joueur est proche du comptoir.")

func _on_body_exited(body):
	if body.name == "player":
		player_near = false
		interaction_panel.visible = false
		print("Le joueur s'est éloigné du comptoir.")

func _process(delta):
	if player_near and Input.is_action_just_pressed("ui_accept"):
		var player = get_tree().current_scene.get_node("player")
		player.add_to_inventory("café", 1)
		print("Tu as pris un café au comptoir ☕")
		player.show_cafe_popup()
