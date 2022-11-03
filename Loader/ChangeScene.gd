extends Node

export(float) var time_before_next_loop:float = 0.1
export(int) var max_loop_count:int = 30

var t = Timer.new()

func _ready():
    t.wait_time = time_before_next_loop
    self.add_child(t)

func go_to_level(tree:SceneTree, target_level_path:String):
    Transitions.play_exit_transition()
    tree.paused = true  
    yield(Transitions, "transition_completed")
    tree.paused = false
    var error = tree.change_scene(target_level_path)
    var counter:int = 0
    while true:
        if error != OK or counter > max_loop_count:
            print("Error changing scene: " + str(error))
            break
        elif error == OK:
            Transitions.play_enter_transition()
            print("GOOD")
            break
        counter += 1
        t.start()
        print("Waiting for scene to load...")
        yield(t, "timeout")
