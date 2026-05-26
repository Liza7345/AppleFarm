extends Control

const NEW_GAME_URL = "http://127.0.0.1:8000/api/session/new/"

@onready var signal_bus = SignalBus
var new_game_button: Button
var _http: HTTPRequest

func _ready() -> void:
	if signal_bus:
		signal_bus.game_ended.connect(_on_game_ended)
	visible = false

	_http = HTTPRequest.new()
	add_child(_http)
	_http.request_completed.connect(_on_request_completed)

	new_game_button = get_node_or_null("Panel/Button")
	if new_game_button:
		new_game_button.pressed.connect(_on_new_game_pressed)

func _on_game_ended() -> void:
	visible = true

func _on_new_game_pressed() -> void:
	new_game_button.disabled = true
	var headers = ["Content-Type: application/json"]
	var err = _http.request(NEW_GAME_URL, headers, HTTPClient.METHOD_POST, JSON.stringify({}))
	if err != OK:
		print("Ошибка запроса новой игры: ", err)
		_start_new_game()

func _on_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var response_text = body.get_string_from_utf8()
	print("Новая игра — ответ сервера: ", response_code, " - ", response_text)
	_start_new_game()

func _start_new_game() -> void:
	visible = false
	new_game_button.disabled = false
	signal_bus.show_start_panel.emit(100)
