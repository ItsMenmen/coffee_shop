extends Area2D

var player_near := false

@onready var interaction_panel = get_tree().current_scene.get_node("UI/InteractionPanel")
@onready var choice_panel = get_tree().current_scene.get_node("UI/ChoicePanel")

func _ready():
	print("✅ Le panneau a bien été trouvé :", interaction_panel)
	print("✅ Le choix a bien été trouvé :", choice_panel)
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
		choice_panel.visible = false
		print("Le joueur s'est éloigné du comptoir.")

func _process(delta):
	if player_near and Input.is_action_just_pressed("ui_accept"):
		print("Interaction avec le comptoir !")
		interaction_panel.visible = false
		choice_panel.visible = true

func _on_btn_cafe_pressed():
	print("Tu as choisi le café ☕")
	choice_panel.visible = false

func _on_btn_beignet_pressed():
	print("Tu as choisi le beignet 🍩")
	choice_panel.visible = false
