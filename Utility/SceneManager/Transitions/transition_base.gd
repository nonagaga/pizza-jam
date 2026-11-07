class_name SceneTransition extends AnimationPlayer

signal on_outro_finished
signal on_intro_finished

@export var outro_animation_name : StringName = "outro"
@export var intro_animation_name : StringName = "intro"
@export var mirror_intro_outro : bool = false

func play_outro():
	if not has_animation(outro_animation_name):
		play(intro_animation_name, -1, speed_scale * -1, true);
	else:
		play(outro_animation_name)
	
	await animation_finished
	on_outro_finished.emit()

func play_intro():
	if not has_animation(intro_animation_name):
		play(outro_animation_name, -1, speed_scale * -1, true);
	else:
		play(intro_animation_name)
		
	await animation_finished
	on_intro_finished.emit()
