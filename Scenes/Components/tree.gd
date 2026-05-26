extends Node2D

@export var physics_collision: CollisionShape2D = null
@export var apples : Array[AppleNode] = []
@export var root : Node2D = null

@onready var animated_sprite = $AnimatedSprite2D
@onready var area = $Area2D
@onready var signal_bus = SignalBus
@onready var apples_fall_trigger = $ApplesFallTrigger


var selection_mode: bool = false
var is_grown: bool = false
var _is_regrowing: bool = false
var _regrow_timers: Array[SceneTreeTimer] = []
var _game_generation: int = 0
var _regrowing_set: Dictionary = {}  # apple -> true, если для него уже запущен таймер

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.input_event.connect(_on_click)
	signal_bus.selection_mode_entered.connect(_on_selection_mode_entered)
	signal_bus.selection_mode_exited.connect(_on_selection_mode_exited)
	signal_bus.game_started.connect(_on_game_started)
	signal_bus.gather_apple.connect(_on_gather_apple)
	signal_bus.load_trees.connect(_on_trees_loaded)
	apples_fall_trigger.set_signal_bus(signal_bus)
	
	_setup_growing_animation()

	for apple in apples:
		apple.visible = false

	animated_sprite.animation_finished.connect(_on_animation_finished)

func _on_game_started(_goal: int) -> void:
	_game_generation += 1
	is_grown = false
	_is_regrowing = false
	_regrow_timers.clear()
	_regrowing_set.clear()
	area.monitoring = true
	area.monitorable = true
	animated_sprite.play("growing")
	for apple in apples:
		apple.set_signal_bus(signal_bus)
		apple.visible = false
		if apple.rigid_body:
			apple.rigid_body.position = Vector2.ZERO
			apple.rigid_body.freeze = true
			apple.rigid_body.visible = true
		
func _on_trees_loaded(trees: Array) -> void:
	for tree_data in trees:
		if tree_data.get("tree_name", "") != name:
			continue

		is_grown = true
		_is_regrowing = false
		_regrow_timers.clear()
		animated_sprite.stop()
		animated_sprite.play("idle")

		var apples_on_tree: int = tree_data.get("apples_on_tree", 0)

		for i in range(apples.size()):
			var apple = apples[i]
			if i < apples_on_tree:
				apple.visible = true
				if apple.rigid_body:
					apple.rigid_body.position = Vector2.ZERO
					apple.rigid_body.freeze = true
					apple.rigid_body.visible = true
			else:
				apple.visible = false
				if apple.rigid_body:
					apple.rigid_body.visible = false

		# Таймеры только для недостающих яблок (если все 5 на месте — не запускаем)
		if apples_on_tree < apples.size():
			_is_regrowing = true
			var gen = _game_generation
			for i in range(apples_on_tree, apples.size()):
				var apple = apples[i]
				_regrowing_set[apple] = true
				var timer = get_tree().create_timer(randf_range(5.0, 35.0))
				_regrow_timers.append(timer)
				timer.timeout.connect(_regrow_apple.bind(apple, gen))
		return
		
func _on_selection_mode_entered():
	selection_mode = true
	
func _on_selection_mode_exited():
	selection_mode = false

func _setup_growing_animation() -> void:
	var texture = load("res://Assets/Game/деревья/derevo_bez_yablok.png")
	const FRAME_W := 62
	const FRAME_H := 76

	var frames := SpriteFrames.new()
	animated_sprite.sprite_frames = frames

	frames.remove_animation("default")

	frames.add_animation("growing")
	frames.set_animation_speed("growing", randf_range(7.0 / 60.0, 3.0))
	frames.set_animation_loop("growing", false)
	for i in range(7):
		var atlas := AtlasTexture.new()
		atlas.atlas = texture
		atlas.region = Rect2(i * FRAME_W, 0, FRAME_W, FRAME_H)
		frames.add_frame("growing", atlas)

	frames.add_animation("idle")
	frames.set_animation_speed("idle", 1.0)
	frames.set_animation_loop("idle", true)
	var idle_atlas := AtlasTexture.new()
	idle_atlas.atlas = texture
	idle_atlas.region = Rect2(6 * FRAME_W, 0, FRAME_W, FRAME_H)
	frames.add_frame("idle", idle_atlas)


func _on_animation_finished() -> void:
	if animated_sprite.animation == "growing":
		is_grown = true
		animated_sprite.play("idle")
		for apple in apples:
			apple.visible = true

func _process(_delta: float) -> void:
	pass

func _on_click(viewport, event, shape_idx):
	if not is_grown:
		return

	if selection_mode and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		signal_bus.current_tree_selected.emit(physics_collision)
		signal_bus.current_tree_selected_root.emit(root)
		_disable_area()


func _on_gather_apple() -> void:
	call_deferred("_check_all_gathered")

func _check_all_gathered() -> void:
	if not is_grown:
		return
	var gen = _game_generation
	for apple in apples:
		if apple.rigid_body == null:
			continue
		# Запускаем таймер только для яблок, которые собраны и у которых нет активного таймера
		if not apple.rigid_body.visible and not _regrowing_set.has(apple):
			_regrowing_set[apple] = true
			_is_regrowing = true
			var timer = get_tree().create_timer(randf_range(5.0, 35.0))
			_regrow_timers.append(timer)
			timer.timeout.connect(_regrow_apple.bind(apple, gen))

func _regrow_apple(apple: AppleNode, generation: int) -> void:
	_regrowing_set.erase(apple)
	if generation != _game_generation:
		_check_all_regrown()
		return
	if not is_grown:
		_check_all_regrown()
		return
	apple.rigid_body.position = Vector2.ZERO
	apple.rigid_body.freeze = true
	apple.rigid_body.visible = true
	apple.visible = true
	_check_all_regrown()

func _check_all_regrown() -> void:
	if not _regrowing_set.is_empty():
		return
	_is_regrowing = false
	_regrow_timers.clear()
	area.monitoring = true
	area.monitorable = true

func get_save_data() -> Dictionary:
	var visible_count := 0
	for apple in apples:
		if apple.rigid_body != null and apple.rigid_body.visible:
			visible_count += 1
	return {
		"tree_name": name,
		"apples_on_tree": visible_count,
		"is_regrowing": _is_regrowing,
	}

func _disable_area() -> void:
	area.set_deferred("monitoring", false)
	area.set_deferred("monitorable", false)
	
	
func _physic_process(delta: float) -> void:
	animated_sprite.play("idle")
