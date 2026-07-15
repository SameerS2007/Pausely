import threading
import uvicorn

import windows_agent
import server

def run_server():
    uvicorn.run(
        server.app,
        host="0.0.0.0",
        port=8000
    )

if __name__ == "__main__":
    server_thread = threading.Thread(
        target=run_server
    )

    monitor_thread = threading.Thread(
        target=windows_agent.run
    )

    server_thread.start()
    monitor_thread.start()