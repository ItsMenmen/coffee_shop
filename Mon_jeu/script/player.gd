extends CharacterBody2D

@export var speed := 250.0
@onready var money_popup = get_tree().current_scene.get_node("UI/MoneyLabel/MoneyPopup")

@onready var inventory_panel = get_tree().current_scene.get_node("UI/InventoryPanel")
@onready var inventory_content = inventory_panel.get_node("VBoxContainer")

var argent = 0
@onready var money_label = get_tree().current_scene.get_node("UI/MoneyLabel")

# 🧺 Inventaire du joueur
var inventory = {
	"café": 0,
	"beignet": 0
}
func add_money(amount: int):
	argent += amount
	money_label.text = "Argent : " + str(argent) + " €"
	show_money_popup()


func show_money_popup():
	money_popup.visible = true
	money_popup.modulate.a = 1.0
	#money_popup.global_position.y += 10  # position de base

	var tween = create_tween()
	tween.tween_property(money_popup, "modulate:a", 0.0, 0.7)  # fade out sur 0.7 sec
	tween.tween_callback(Callable(money_popup, "hide"))

func _physics_process(delta):
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")

	velocity = direction.normalized() * speed
	move_and_slide()

	var anim_sprite = $Sprite2D as AnimatedSprite2D

	if direction != Vector2.ZERO:
		if direction.y < 0:
			anim_sprite.play("up")
		elif direction.y > 0:
			anim_sprite.play("up")  # même animation que "down"
		else:
			anim_sprite.play("walk")

		if direction.x != 0:
			anim_sprite.flip_h = direction.x < 0
	else:
		anim_sprite.stop()

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		inventory_panel.visible = !inventory_panel.visible
		if inventory_panel.visible:
			update_inventory_display()

# 🔄 Met à jour le contenu de l'inventaire
func update_inventory_display():
	for child in inventory_content.get_children():
		child.queue_free()

	for item in inventory.keys():
		var label = Label.new()
		label.text = item.capitalize() + " x" + str(inventory[item])
		inventory_content.add_child(label)

# 🍩 Ajoute un objet à l’inventaire
func add_to_inventory(item_name: String, quantity := 1):
	if inventory.has(item_name):
		inventory[item_name] += quantity
	else:
		inventory[item_name] = quantity

	if inventory_panel.visible:
		update_inventory_display()
		
func show_cafe_popup():
	var popup = $CafePopup
	popup.visible = true

	# Attendre 0.7s et cacher
	await get_tree().create_timer(0.7).timeout
	popup.visible = false
