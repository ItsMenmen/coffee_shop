extends CharacterBody2D

@export var speed := 250.0

func _physics_process(delta):
	var direction = Vector2.ZERO

	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")

	velocity = direction.normalized() * speed
	move_and_slide()

	var anim_sprite = $Sprite2D as AnimatedSprite2D

	if direction != Vector2.ZERO:
		# Choisir quelle animation jouer selon la direction
		if direction.y < 0:
			anim_sprite.play("up")
		elif direction.y > 0:
			anim_sprite.play("up")
		else:
			anim_sprite.play("walk")  # gauche / droite

		# Flip horizontal si va à gauche
		if direction.x != 0:
			anim_sprite.flip_h = direction.x < 0
	else:
		anim_sprite.stop()
