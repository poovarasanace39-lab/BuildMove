from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from .core.config import settings
from .websocket.connection_manager import manager

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    openapi_url=f"{settings.API_V1_STR}/openapi.json",
)

# Enable CORS for mobile development and web portals
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {
        "app": "BuildMove Heavy Material Logistics API",
        "version": settings.VERSION,
        "status": "online",
        "docs": "/docs",
    }

@app.websocket("/ws/tracking/{booking_id}")
async def tracking_websocket(websocket: WebSocket, booking_id: str):
    await manager.connect(booking_id, websocket)
    try:
        while True:
            data = await websocket.receive_json()
            # Broadcast driver's GPS updates to customers tracking this booking
            await manager.broadcast_location(booking_id, data)
    except WebSocketDisconnect:
        manager.disconnect(booking_id, websocket)
