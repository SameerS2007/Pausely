import psutil as ps
import time as tm
import state

process_names = [
    "placeholder"
]

def check_proc():
    for process in ps.process_iter():
        try:
            if process.name() in process_names:
                return process
        except ps.NoSuchProcess:
            pass
    
    return None


def run():
    id = 0
    while True:
        if not state.authorized:
            proc = check_proc()
            if proc is not None:
                try:
                    state.events.append({
                        "id": id,
                        "type": "VIOLATION",
                        "game": proc.name()
                    })
                    id += 1
                    proc.terminate()
                except ps.NoSuchProcess:
                    pass
        tm.sleep(4)
