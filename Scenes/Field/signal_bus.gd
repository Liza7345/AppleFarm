extends Node

signal game_started(goal: int)

signal selection_mode_entered()
signal selection_mode_exited()
signal current_tree_selected(tree_collider : CollisionShape2D)
signal current_tree_selected_root(tree: Node2D)
signal apples_fall()
signal show_basket(position : Vector2)
signal hide_basket()
signal gather_apple()
signal sale_zone_opened()
signal sell_apples(count: int, total_coins: int)

signal game_ended()

# Новые сигналы для управления UI
signal show_start_panel(goal: int)  # Показать панель старта с указанной целью
signal hide_start_panel()  # Скрыть панель старта
signal game_loaded()            # Загружено сохранение (без параметров)
signal load_goal(goal: int)     # Восстановление цели из сохранения
signal game_load_failed()
signal load_trees(trees)
signal load_coins(coins)
signal load_apples_collected(apples_collected)
