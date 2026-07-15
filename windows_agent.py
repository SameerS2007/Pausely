import psutil as ps
import time as tm

c = 100

process_names = [
    "placeholder"
]

auth = True # Connected with sockets later but placeholder for noq


def check_proc():
    for process in ps.process_iter():
        try:
            if process.info["name"] in process_names:
                return process
        except ps.NoSuchProcess:
            pass
    
    return None


if __name__ == "__main__":
    while True:
        if auth:
            proc = check_proc()
            if proc is not None:
                try:
                    proc.terminate()
                except ps.NoSuchProcess:
                    pass
        tm.sleep(4)
