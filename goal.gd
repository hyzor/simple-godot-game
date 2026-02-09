extends Area2D

signal level_completed

@export var goal_text: String = "Congratulations!"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		level_completed.emit()
		_show_victory_ui()

var victory_ui: CanvasLayer = null

func _show_victory_ui() -> void:
	victory_ui = CanvasLayer.new()
	victory_ui.layer = 100
	get_tree().root.add_child(victory_ui)
	
	var center_container = CenterContainer.new()
	center_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	victory_ui.add_child(center_container)
	
	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	center_container.add_child(vbox)
	
	var panel = Panel.new()
	panel.custom_minimum_size = Vector2(400, 200)
	vbox.add_child(panel)
	
	var label = Label.new()
	label.text = goal_text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 32)
	label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	panel.add_child(label)
	
	var restart_label = Label.new()
	restart_label.text = "Press R to restart"
	restart_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	restart_label.add_theme_font_size_override("font_size", 18)
	vbox.add_child(restart_label)
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if victory_ui and event.is_action_pressed("restart"):
		_restart_level()

func _restart_level() -> void:
	get_tree().paused = false
	process_mode = Node.PROCESS_MODE_INHERIT
	if victory_ui:
		victory_ui.queue_free()
		victory_ui = null
	set_process_input(false)
	get_tree().reload_current_scene()
