extends CharacterBody2D

@onready var personaje = get_node("/root/Game/Personaje")# Asegúrate de que AnimatedSprite2D esté correctamente ubicado
var is_dead = false
var health = 2


	


func _physics_process(delta):
	if is_dead:
		return  # Si está muerto, no se mueve más
	
	var direction = global_position.direction_to(personaje.global_position)
	velocity = direction * 50.0
	move_and_slide()

func take_damage():
	health -= 1
	if health == 0:
		play_death_animation()
		queue_free()
	

func die():
	if is_dead:
		return  # Evitar múltiples llamadas a la muerte
	
	is_dead = true
	play_death_animation()
	await get_tree().create_timer(0.5).timeout  # Espera la duración de la animación de muerte
	queue_free()  # Eliminar al enemigo después de la animación

func play_death_animation():
	# Reproduce la animación de muerte en función de la dirección
	if personaje.global_position.x > global_position.x:
		$Zombie/AnimatedSprite2D.play("Death Right")
	elif personaje.global_position.x < global_position.x:
		$Zombie/AnimatedSprite2D.play("Death Left")
	elif personaje.global_position.y > global_position.y:
		$Zombie/AnimatedSprite2D.play("Death Down")
	elif personaje.global_position.y < global_position.y:
		$Zombie/AnimatedSprite2D.play("Death Up")
