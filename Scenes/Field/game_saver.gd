extends Node

const SAVE_URL = "http://127.0.0.1:8000/api/session/save/"

var apples_collected: int = 0
var coins: int = 0
var goal: int = 0
var game_active: bool = false

var _quitting: bool = false
var _http: HTTPRequest

func _ready() -> void:
	_http = HTTPRequest.new()
	add_child(_http)
	_http.request_completed.connect(_on_request_completed)

	get_tree().set_auto_accept_quit(false)

	SignalBus.game_started.connect(_on_game_started)
	SignalBus.load_goal.connect(_on_load_goal)
	SignalBus.gather_apple.connect(_on_gather_apple)
	SignalBus.sell_apples.connect(_on_sell_apples)
	SignalBus.load_apples_collected.connect(_on_load_apples_collected)
	SignalBus.load_coins.connect(_on_load_coins)

func _on_game_started(g: int) -> void:
	goal = g
	apples_collected = 0
	coins = 0
	game_active = true

func _on_load_goal(g: int) -> void:
	goal = g

func _on_load_apples_collected(apples: int) -> void:
	apples_collected = apples

func _on_load_coins(coins_val: int) -> void:
	coins = coins_val

func _on_gather_apple() -> void:
	apples_collected += 1

func _on_sell_apples(count: int, total_coins: int) -> void:
	apples_collected -= count
	if apples_collected < 0:
		apples_collected = 0
	coins = total_coins

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_save_and_quit()

func _save_and_quit() -> void:
	if not game_active:
		get_tree().quit()
		return
	_quitting = true
	var err = save()
	if err != OK:
		get_tree().quit()
		return
	# Выход через 3 секунды если сервер не ответил
	get_tree().create_timer(3.0).timeout.connect(func(): get_tree().quit())

func save() -> Error:
	var trees_data: Array = []
	for tree in get_tree().get_nodes_in_group("trees"):
		if tree.has_method("get_save_data"):
			trees_data.append(tree.get_save_data())

	var payload = {
		"apples_collected": apples_collected,
		"coins": coins,
		"goal": goal,
		"trees": trees_data,
	}

	var headers = ["Content-Type: application/json"]
	return _http.request(
		SAVE_URL,
		headers,
		HTTPClient.METHOD_POST,
		JSON.stringify(payload)
	)

func _on_request_completed(_result: int, _code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	if _quitting:
		get_tree().quit()
