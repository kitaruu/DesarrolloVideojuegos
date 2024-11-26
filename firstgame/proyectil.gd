extends Area2D

var speed = 200  # Velocidad del proyectil
var direction = Vector2.ZERO  # Dirección en la que se lanzará el proyectil
var travelled_distance = 0

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("body_entered", Callable(self, "_on_body_entered"))
	print("Señales de colisión conectadas")

func _physics_process(delta):
	const RANGE = 1200
	position += direction * speed * delta

	# Eliminar el proyectil si ha alcanzado su rango
	travelled_distance += speed * delta
	if travelled_distance > RANGE:
		queue_free()

func _on_area_entered(area):
	print("Colisión detectada con:", area.name)  # Depuración
	if area.is_in_group("Enemies"):  # Verifica si el área está en el grupo "Enemies"
		print("Colisión con el enemigo detectada")
		area.die()  # Llama a la función de muerte del enemigo
		queue_free()  # Destruye el proyectil después de la colisión

func _on_body_entered(body):
	print("Colisión detectada con cuerpo:", body.name)
	if body.has_method("take_damage"):
		body.take_damage()
	
