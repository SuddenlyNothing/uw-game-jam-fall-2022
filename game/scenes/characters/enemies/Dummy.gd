extends StaticBody2D

const CollectableSoul := preload("res://scenes/characters/CollectableSoul.tscn")

export(int) var num_souls := 3


func _on_EnemyHurtbox_hit() -> void:
	for i in num_souls:
		var cs := CollectableSoul.instance()
		cs.position = position
		get_parent().call_deferred("add_child", cs)
