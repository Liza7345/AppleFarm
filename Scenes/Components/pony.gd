extends Node2D

@export var signal_bus : SignalBus = null
@export var move_speed: float = 200.0 

@onready var area = $Area2D
@onready var lable_node = $Label
@onready var animated_sprite = $AnimatedSprite2D

var player_in_range: bool = false
var target_tree: Node = null
var is_moving_to_tree : bool = true
var current_point : Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	
	signal_bus.current_tree_selected.connect(_on_current_tree_selected)
	lable_node.visible = false

func _on_current_tree_selected(shape : CollisionShape2D):
	is_moving_to_tree = true
	current_point = get_closest_point_on_rectangle(shape)
	print(current_point)
	hide_selection_promt()
	start_moving_to_tree()

# Возвращает ближайшую точку на прямоугольном коллайдере к позиции пони
func get_closest_point_on_rectangle(collision: CollisionShape2D) -> Vector2:
	if not collision or not collision.shape:
		return global_position
	
	var shape = collision.shape as RectangleShape2D
	var rect = Rect2(
		collision.global_position - shape.size / 2,
		shape.size
	)
	
	return Vector2(
		clamp(global_position.x, rect.position.x, rect.position.x + rect.size.x),
		clamp(global_position.y, rect.position.y, rect.position.y + rect.size.y)
	)

func _on_body_entered(body):
	print ("body_entered")
	if body.name == "Девочка":
		player_in_range = true
		show_selection_promt()
		signal_bus.selection_mode_entered.emit()

func _on_body_exited(body):
	print ("body_entered")
	if body.name == "Девочка":
		player_in_range = false
		hide_selection_promt()
		signal_bus.selection_mode_exited.emit()

func hide_selection_promt():
	lable_node.visible = false
	
func show_selection_promt():
	if lable_node:
		lable_node.text = "🌳 Выбрать дерево"
		lable_node.visible = true

func start_moving_to_tree():
	is_moving_to_tree = true
	print("🦄 Пони движется к точке: ", current_point)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Движение пони
	if is_moving_to_tree and current_point != Vector2.ZERO:
		move_towards_tree(delta)
		# Обновляем анимацию в зависимости от направления
		update_movement_animation(direction)
		
func move_towards_tree(delta):
	var distance = global_position.distance_to(current_point)
	direction = (current_point - global_position).normalized()
	global_position += direction * move_speed * delta
	# Если достигли дерева (близко)
	if distance < 20:
		is_moving_to_tree = false
		on_reached_tree()
		
func on_reached_tree():
	print("🦄 Пони достигла дерева!")
	
	# Поворачиваем пони к дереву (опционально)
	face_tree()
	
	print("пони развернулась")
	# Запускаем анимацию удара
	animated_sprite.play("idle_hit")
	
	# Ждём окончания анимации
	await animated_sprite.animation_finished
	
	# Собираем яблоки
	collect_apples()
	
func face_tree():
	# Поворачиваем пони лицом к дереву
	var direction = current_point - global_position
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			animated_sprite.scale.x = abs(animated_sprite.scale.x)
		else:
			animated_sprite.scale.x = -abs(animated_sprite.scale.x)

func collect_apples():
	#TODO: появляется корзинка
	print("Анимация закончила играть")
	pass
	
func update_movement_animation(direction):
	# Обновляем анимацию в зависимости от направления
	if direction.x > 0:
		animated_sprite.play("idle_right")
		animated_sprite.scale.x = abs(animated_sprite.scale.x)
	else:
		animated_sprite.play("idle_right")
		animated_sprite.scale.x = -abs(animated_sprite.scale.x)
	
