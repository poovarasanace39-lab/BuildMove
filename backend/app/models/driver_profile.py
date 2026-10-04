from sqlalchemy import Column, String, Boolean, Float, Integer, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime
import uuid
from ..core.database import Base

class DriverProfile(Base):
    __tablename__ = "driver_profiles"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), unique=True, nullable=False)
    is_online = Column(Boolean, default=False)
    license_number = Column(String(50), nullable=False)
    rating = Column(Float, default=5.0)
    total_trips = Column(Integer, default=0)
    earnings_today = Column(Float, default=0.0)
    is_approved = Column(Boolean, default=False)
    rejection_reason = Column(String(255), nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    user = relationship("User", back_populates="driver_profile")
    vehicles = relationship("Vehicle", back_populates="driver")
