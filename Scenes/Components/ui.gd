extends Node2D

@export var apples_counter: Label = null
@export var coins_counter: Label = null

@onready var signal_bus = SignalBus

var apples_count: int = 0
var coins_count: int = 0
var goal: int = 0

func _ready() -> void:
	signal_bus.gather_apple.connect(_on_gather_apple)
	signal_bus.sell_apples.connect(_on_sell_apples)
	signal_bus.load_apples_collected.connect(_on_apples_collected_loaded)
	signal_bus.load_coins.connect(_on_coins_loaded)
	signal_bus.game_started.connect(_on_game_started)
	signal_bus.load_goal.connect(_on_load_goal)

func _update_coins_label() -> void:
	if coins_counter:
		coins_counter.text = str(coins_count) + "/" + str(goal)

func _on_game_started(g: int) -> void:
	goal = g
	apples_count = 0
	coins_count = 0
	apples_counter.text = "0"
	_update_coins_label()

func _on_load_goal(g: int) -> void:
	goal = g
	_update_coins_label()

func _on_apples_collected_loaded(apples: int) -> void:
	apples_count = apples
	apples_counter.text = str(apples_count)

func _on_coins_loaded(coins: int) -> void:
	coins_count = coins
	_update_coins_label()

func _on_gather_apple() -> void:
	apples_count += 1
	apples_counter.text = str(apples_count)

func _on_sell_apples(sold_count: int, total_coins: int) -> void:
	apples_count -= sold_count
	if apples_count < 0:
		apples_count = 0
	apples_counter.text = str(apples_count)
	coins_count = total_coins
	_update_coins_label()
