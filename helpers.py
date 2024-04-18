DEBUG = True

def clear_terminal():
    print("\033c")

def console_log(*context):
    if DEBUG:
        print(context)

def not_implemented():
    raise Exception(NotImplemented)