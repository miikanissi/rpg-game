extends AnimatedSprite

# Effect script that can be instanced for different effects

func _ready():
	connect("animation_finished", self, "_on_animation_finished")
	frame = 0
	play("Animate")

func _on_animation_finished():
	queue_free()
