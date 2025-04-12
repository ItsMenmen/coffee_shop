extends Area2D

@onready var speech_bubble = $SpeechBubble
@onready var label = $SpeechBubble/Label
@onready var static_body = $StaticBody2D
@onready var visual = $Visual
@onready var sprite = $Visual/Sprite2D  # important pour déplacer le visuel

@onready var exit_point = get_node("/root/café/ExitPoint")  # point de sortie

@export var visual_scale: Vector2 = Vector2(0.15, 0.15)  # pour garder la même taille que l'arrivée
var player_near = false
var has_received_coffee = false
var leaving := false
var speed := 100.0

func _ready():
	sprite.scale = visual_scale
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
	# Déplacement vers ExitPoint
	if leaving:
		var direction = (exit_point.global_position - global_position).normalized()
		var distance = global_position.distance_to(exit_point.global_position)

		if distance > 5.0:
			global_position += direction * speed * delta
		else:
			print("👋 Client a quitté le café.")
			queue_free()

	# Interaction avec le joueur
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

			await get_tree().create_timer(1.0).timeout
			leave_cafe()
		else:
			print("Client : Tu n’as pas de café à me donner.")
			speak("Tu n’as pas de café 😢")

func speak(text: String):
	label.text = text
	speech_bubble.visible = true

func hide_bubble():
	speech_bubble.visible = false

func set_texture(tex: Texture):
	if tex:
		sprite.texture = tex
		sprite.scale = visual_scale

func leave_cafe():
	leaving = true
	# On désactive la collision pour pas bloquer
	static_body.set_deferred("disabled", true)
