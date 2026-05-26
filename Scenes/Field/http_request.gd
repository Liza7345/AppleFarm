extends HTTPRequest

@onready var signal_bus = SignalBus

func _ready() -> void:
	request_completed.connect(_on_request_completed)
	load_saved_game()

func load_saved_game() -> void:
	var url = "http://127.0.0.1:8000/api/session/load/"
	var error = request(url)
	if error != OK:
		print("Ошибка загрузки: ", error)
		signal_bus.game_load_failed.emit()
		signal_bus.show_start_panel.emit(100)
	else:
		print("Запрос на загрузку отправлен")

func reset_on_server() -> void:
	var url = "http://localhost:8000/api/session/new/"
	var headers = ["Content-Type: application/json"]
	var body = JSON.stringify({})
	var error = request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		print("Ошибка сброса: ", error)

func save_game_state(apples_collected: int, coins: int, goal: int, trees_data: Array) -> void:
	var url = "http://127.0.0.1:8000/api/session/save/"
	var headers = ["Content-Type: application/json"]
	var body = JSON.stringify({
		"apples_collected": apples_collected,
		"coins": coins,
		"goal": goal,
		"trees": trees_data
	})
	var error = request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		print("Ошибка сохранения: ", error)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response_text = body.get_string_from_utf8()
	var json = JSON.parse_string(response_text)

	print("Ответ сервера: ", response_code, " - ", response_text)

	if response_code != 200:
		print("Ошибка сервера: ", response_code)
		signal_bus.game_load_failed.emit()
		signal_bus.show_start_panel.emit(100)
		return

	if json and json.has("found"):
		# Это ответ на load_session
		signal_bus.game_started.emit(json.goal)
		if json.found:
			print("Нашли сохранённую сессию")
			var has_progress = json.goal != 0
			if has_progress:
				signal_bus.load_goal.emit(json.goal)
				signal_bus.load_coins.emit(json.coins)
				signal_bus.load_apples_collected.emit(json.apples_collected)
				signal_bus.game_loaded.emit()
				signal_bus.hide_start_panel.emit()
			else:
				signal_bus.show_start_panel.emit(json.goal)
		else:
			signal_bus.game_load_failed.emit()
			signal_bus.show_start_panel.emit(100)

	elif json and json.has("status"):
		if json.status == "new_game":
			print("Сервер сброшен")
		elif json.status == "saved":
			print("Игра сохранена")
