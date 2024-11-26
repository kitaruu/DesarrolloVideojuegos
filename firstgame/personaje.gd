extends CharacterBody2D

var last_direction = Vector2.ZERO
var is_attacking = false
var ProyectilScene = preload("res://proyectil.tscn")  # Asegúrate de que la ruta al proyectil es correcta

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Iniciar el ataque si no estamos ya atacando
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		play_attack_animation()
		disparar_proyectil()
		await get_tree().create_timer(0.3).timeout  # Espera 0.3 segundos antes de finalizar el ataque
		is_attacking = false
		return
	
	# Movimiento solo si no estamos atacando
	if not is_attacking:
		velocity = direction * 200
		move_and_slide()
		if direction != Vector2.ZERO:
			last_direction = direction.normalized()  # Normalizar para solo tomar direcciones cardinales
			if direction.x > 0:
				$Node2D/AnimatedSprite2D.play("walk right")
			elif direction.x < 0:
				$Node2D/AnimatedSprite2D.play("walk left")
			elif direction.y < 0:
				$Node2D/AnimatedSprite2D.play("walk back")
			elif direction.y > 0:
				$Node2D/AnimatedSprite2D.play("walk front")
		else:
			# Animación de Idle basada en la última dirección
			if last_direction.x > 0:
				$Node2D/AnimatedSprite2D.play("Idle Right")
			elif last_direction.x < 0:
				$Node2D/AnimatedSprite2D.play("Idle Left")
			elif last_direction.y > 0:
				$Node2D/AnimatedSprite2D.play("Idle Front")
			elif last_direction.y < 0:
				$Node2D/AnimatedSprite2D.play("Idle Back")

func play_attack_animation():
	if last_direction.x > 0:
		$Node2D/AnimatedSprite2D.play("Shoot Right")
	elif last_direction.x < 0:
		$Node2D/AnimatedSprite2D.play("Shoot Left")
	elif last_direction.y > 0:
		$Node2D/AnimatedSprite2D.play("Shoot Front")
	elif last_direction.y < 0:
		$Node2D/AnimatedSprite2D.play("Shoot Back") 

	print("Conectada señal animation_finished")

func disparar_proyectil():
	const proyectil = preload("res://proyectil.tscn")
	var nuevo_proyectil = proyectil.instantiate()
	
	nuevo_proyectil.position = position
	
	if last_direction.x > 0:
		nuevo_proyectil.direction = Vector2.RIGHT
	elif last_direction.x < 0:
		nuevo_proyectil.direction = Vector2.LEFT
	elif last_direction.y > 0:
		nuevo_proyectil.direction = Vector2.DOWN
	elif last_direction.y < 0:
		nuevo_proyectil.direction = Vector2.UP
	get_tree().root.get_node("Game").add_child(nuevo_proyectil)  # Cambia "Game" por el nodo raíz correcto si es necesario

func _on_attack_timer_timeout():
	disparar_proyectil()
	pass # Replace with function body.
