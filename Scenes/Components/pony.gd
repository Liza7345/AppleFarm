extends Node2D
var player_in_range: bool = false
var selection_mode: bool = false
var target_tree: Node = null
@onready var area = $Area2D
@onready var lable_node = $Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	lable_node.visible = false

func _on_body_entered(body):
	print ("body_entered")
	if body.name == "Девочка":
		player_in_range = true
		show_selection_promt()
		selection_mode = true

func _on_body_exited(body):
	print ("body_entered")
	if body.name == "Девочка":
		player_in_range = false
		hide_selection_promt()
		selection_mode = false

func hide_selection_promt():
	lable_node.visible = false
	
func show_selection_promt():
	if lable_node:
		lable_node.text = "🌳 Выбрать дерево"
		lable_node.visible = true
func select_tree_under_mouse():
 # Получаем позицию мыши на сцене
	var mouse_pos = get_global_mouse_position()
	 # Ищем дерево под мышью
	var trees = get_tree().get_nodes_in_group("trees")
	print(trees)
	var selected = null
	for tree in trees:
	  # Проверяем, есть ли у дерева CollisionShape2D
		if tree.has_node("CollisionShape2D"):
			var collision = tree.get_node("CollisionShape2D") as CollisionShape2D
	   # Получаем прямоугольник коллизии
			var rect = Rect2(
			tree.global_position - collision.shape.size / 2,
			collision.shape.size
			) 
			if rect.has_point(mouse_pos):
				selected = tree
				break
		else:
			# Простая проверка по расстоянию
			var dist = tree.global_position.distance_to(mouse_pos)
			if dist < 32:  # радиус клика
				selected = tree
				break
	if selected:
		target_tree = selected
		print("✅ Выбрано дерево: ", target_tree.name)
		# Завершаем режим выбора
		hide_selection_promt()
		# Здесь можно запустить анимацию пони или сбор яблок
		on_tree_selected()

func on_tree_selected():
	print("Дерево выбрано")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if selection_mode and Input.is_action_just_pressed("Clik"):
		print("Нажатие")
		select_tree_under_mouse()
