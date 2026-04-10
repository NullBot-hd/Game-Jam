extends ProgressBar

@onready var healthbar: ProgressBar = $"."
@onready var damagebar = $Damagebar
@onready var timer = $Timer

func _ready():
	timer.timeout.connect(_on_timer_timeout)

func init_health(max_health: float):
	max_value = max_health
	value = max_health
	
	damagebar.max_value = max_health
	damagebar.value = max_health

func set_display_health(new_health: float):
	tween(healthbar, new_health)
	
	timer.start()

func _on_timer_timeout():
	tween(damagebar, value)
	
func tween(progress_bar: ProgressBar, tweenVal: int):
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(progress_bar, "value", tweenVal, 0.4)
