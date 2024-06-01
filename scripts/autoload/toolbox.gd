extends Node

var mute: bool

func update_text(node: Node, type: int, num1: int, num2: int = 0):
    match type:
        0: #simple
            node.text = '%d' % num1
        1: #pomodoro
            node.text =  '%d/%d' % [num1, num2]
        2: #time
            node.text = '%02d:%02d' % [num1, num2]
        