extends Control

@onready var grid_container: GridContainer = %GridContainer

class Monitor:
  var _field: Label
  var _callback: Callable

  func _init(field: Label, callback: Callable) -> void:
    _field = field
    _callback = callback

  func update() -> void:
    _field.text = _callback.call()

var _monitors: Array[Monitor]

func _ready() -> void:
  register_monitor("FPS", _get_performance_singleton_monitor.bind(Performance.TIME_FPS))
  register_monitor("Process time", _get_performance_singleton_monitor.bind(Performance.TIME_PROCESS))
  register_monitor("Physics time", _get_performance_singleton_monitor.bind(Performance.TIME_PHYSICS_PROCESS))
  register_monitor("Memory", _get_performance_singleton_monitor.bind(Performance.MEMORY_STATIC))
  register_monitor("Objects", _get_performance_singleton_monitor.bind(Performance.OBJECT_COUNT))

func register_monitor(label_text: String, callback: Callable) -> void:
  var label = Label.new()
  label.text = label_text
  grid_container.add_child(label)

  var field = Label.new()
  grid_container.add_child(field)

  var monitor = Monitor.new(field, callback)
  _monitors.push_back(monitor)

func _get_performance_singleton_monitor(monitor) -> String:
  return "%.03f" % Performance.get_monitor(monitor)

func _on_timer_timeout() -> void:
  for monitor in _monitors:
    monitor.update()
