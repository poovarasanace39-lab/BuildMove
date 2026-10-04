from sqlalchemy import Column, String, Float, ForeignKey, DateTime, JSON
from sqlalchemy.orm import relationship
from datetime import datetime
import uuid
from ..core.database import Base

class Trip(Base):
    __tablename__ = "trips"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    booking_id = Column(String, ForeignKey("bookings.id"), unique=True, nullable=False)
    driver_id = Column(String, ForeignKey("users.id"), nullable=False)
    start_time = Column(DateTime, default=datetime.utcnow)
    end_time = Column(DateTime, nullable=True)
    start_odometer = Column(Float, nullable=True)
    end_odometer = Column(Float, nullable=True)
    current_location = Column(JSON, nullable=True)

    booking = relationship("Booking", back_populates="trip")
