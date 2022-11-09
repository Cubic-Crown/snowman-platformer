extends CanvasLayer

class_name TransitionManager

onready var animationPlayer = null
signal transition_completed

var roundTransition = preload("res://MapUtilities/RoundTransition.tscn")
var fadeTransition = preload("res://MapUtilities/FadeTransitions.tscn")


enum transitions { ROUND, FADE }
var transition = transitions.ROUND setget setTransition


func setTransition(v) :
	var trans = { transitions.FADE : fadeTransition, transitions.ROUND : roundTransition }
	delete_children($TransitionParent)
	var t = trans[v].instance()
	$TransitionParent.add_child(t)
	animationPlayer = t.get_node("AnimationPlayer")
	animationPlayer.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")

func play_exit_transition():
	animationPlayer.play("ExitLevel")

func play_enter_transition():
	animationPlayer.play("EnterLevel")

func _on_AnimationPlayer_animation_finished(_anim_name):
	emit_signal("transition_completed")


static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
