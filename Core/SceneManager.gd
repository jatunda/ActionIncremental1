extends Node

const drafting_scene_path : String = "res://Core/DraftingScene.tscn"
const upgrades_scene_path : String = "res://Core/upgrades_scene.tscn"
const start_scene_path : String = "res://Core/StartScreen.tscn"
const save_load_scene_path : String = "res://Core/save_load_screen.tscn"
var current_scene : Node

func go_to_drafting_scene() -> void:
	#print_debug("go to drafting scene")
	_go_to_scene(drafting_scene_path)
	pass

func go_to_upgrades_scene() -> void:
	#print_debug("go to upgrades scene")
	_go_to_scene(upgrades_scene_path)
	pass

func go_to_start_scene() -> void:
	#print_debug("go to start scene")
	_go_to_scene(start_scene_path)
	pass

func go_to_save_load_scene() -> void:
	_go_to_scene(save_load_scene_path)

func _go_to_scene(scene_path: String) -> void:
	current_scene.queue_free()
	var packed_scene = load(scene_path)
	var scene_instance = packed_scene.instantiate()
	add_child(scene_instance)
	current_scene = scene_instance
