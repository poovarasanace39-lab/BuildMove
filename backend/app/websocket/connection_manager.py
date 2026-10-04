from typing import Dict, List
from fastapi import WebSocket
import json

class TrackingConnectionManager:
    def __init__(self):
        # Maps booking_id to a list of listening client WebSockets (customers + drivers + admin)
        self.active_rooms: Dict[str, List[WebSocket]] = {}

    async def connect(self, booking_id: str, websocket: WebSocket):
        await websocket.accept()
        if booking_id not in self.active_rooms:
            self.active_rooms[booking_id] = []
        self.active_rooms[booking_id].append(websocket)

    def disconnect(self, booking_id: str, websocket: WebSocket):
        if booking_id in self.active_rooms:
            if websocket in self.active_rooms[booking_id]:
                self.active_rooms[booking_id].remove(websocket)
            if not self.active_rooms[booking_id]:
                del self.active_rooms[booking_id]

    async def broadcast_location(self, booking_id: str, payload: dict):
        if booking_id in self.active_rooms:
            for connection in self.active_rooms[booking_id]:
                try:
                    await connection.send_text(json.dumps(payload))
                except Exception:
                    pass

manager = TrackingConnectionManager()
