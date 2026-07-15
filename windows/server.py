from fastapi import FastAPI
from fastapi import WebSocket
import state
import asyncio
#import websockets

app = FastAPI()

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()

    await asyncio.gather(
        receive_message(websocket),
        send_message(websocket)
    )

        


async def receive_message(websocket: WebSocket):
    while True:
        message = await websocket.receive_json()

        if message["type"] == "START_SESSION":
            state.authorized = True
        elif message["type"] == "END_SESSION":
            state.authorized = False

async def send_message(websocket: WebSocket):
    while True:
        if state.events:
                event = state.events.popleft()
                await websocket.send_json(event)
        await asyncio.sleep(0.1)