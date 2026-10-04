from sqlalchemy import Column, String, Float, ForeignKey, DateTime, Boolean, JSON
from datetime import datetime
import uuid
from ..core.database import Base

class Review(Base):
    __tablename__ = "reviews"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    booking_id = Column(String, ForeignKey("bookings.id"), nullable=False)
    author_id = Column(String, ForeignKey("users.id"), nullable=False)
    rating = Column(Float, nullable=False)
    comment = Column(String(500), nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

class AppNotification(Base):
    __tablename__ = "notifications"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), nullable=False)
    title = Column(String(120), nullable=False)
    body = Column(String(255), nullable=False)
    type = Column(String(50), nullable=False)
    is_read = Column(Boolean, default=False)
    metadata_json = Column(JSON, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
