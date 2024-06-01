extends Node

static func update_text(node: Node, type: int, num1: int, num2: int = 0):
    match type:
        0: #simple
            node.text =  '%d' % num1