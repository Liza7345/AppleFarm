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
