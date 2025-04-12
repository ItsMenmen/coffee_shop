extends Area2D

@onready var speech_bubble = $SpeechBubble
@onready var label = $SpeechBubble/Label
@onready var static_body = $StaticBody2D
@onready var visual = $Visual

var player_near = false
var has_received_coffee = false

func _ready():
	speak("Je voudrais un café ☕")
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	if body.name == "player":
		player_near = true

func _on_body_exited(body):
	if body.name == "player":
		player_near = false

func _process(delta):
	if player_near and Input.is_action_just_pressed("ui_accept") and not has_received_coffee:
		var player = get_tree().current_scene.get_node("player")
		
		if player.inventory.has("café") and player.inventory["café"] > 0:
			player.inventory["café"] -= 1
			player.update_inventory_display()
			player.add_money(1)

			has_received_coffee = true
			speak("Merci ☕ !")
			print("Client : Merci pour le café !")

			await get_tree().create_timer(2.0).timeout
			hide_bubble()
		else:
			print("Client : Tu n’as pas de café à me donner.")
			speak("Tu n’as pas de café 😢")

func speak(text: String):
	label.text = text
	speech_bubble.visible = true

func hide_bubble():
	speech_bubble.visible = false

# 🔁 Appliquer dynamiquement la texture depuis customer2
func set_texture(tex: Texture):
	if tex:
		$Visual/Sprite2D.texture = tex
		$Visual/Sprite2D.scale = Vector2(0.2, 0.2)
