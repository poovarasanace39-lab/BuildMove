from sqlalchemy import Column, String, Float, ForeignKey, DateTime, Enum as SQLEnum, JSON
from sqlalchemy.orm import relationship
import enum
from datetime import datetime
import uuid
from ..core.database import Base

class BookingStatusEnum(str, enum.Enum):
    pending = "pending"
    searching = "searching"
    accepted = "accepted"
    arriving = "arriving"
    in_progress = "in_progress"
    completed = "completed"
    cancelled = "cancelled"

class MaterialTypeEnum(str, enum.Enum):
    cement = "cement"
    sand = "sand"
    steel = "steel"
    bricks = "bricks"
    aggregates = "aggregates"
    tiles = "tiles"
    timber = "timber"
    debris = "debris"

class Booking(Base):
    __tablename__ = "bookings"

    id = Column(String, primary_key=True, default=lambda: f"BM-{uuid.uuid4().hex[:8].upper()}")
    customer_id = Column(String, ForeignKey("users.id"), nullable=False)
    driver_id = Column(String, ForeignKey("users.id"), nullable=True)

    vehicle_type = Column(String(50), nullable=False)
    material_type = Column(SQLEnum(MaterialTypeEnum), nullable=False)
    quantity_tons = Column(Float, nullable=False)

    pickup_location = Column(JSON, nullable=False)  # {latitude, longitude, address, landmark}
    drop_location = Column(JSON, nullable=False)    # {latitude, longitude, address, landmark}

    status = Column(SQLEnum(BookingStatusEnum), default=BookingStatusEnum.pending, nullable=False)
    estimated_fare = Column(Float, nullable=False)
    actual_fare = Column(Float, nullable=True)
    distance_km = Column(Float, nullable=False)

    otp_for_pickup = Column(String(6), nullable=True)
    scheduled_at = Column(DateTime, default=datetime.utcnow)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relationships
    customer = relationship("User", foreign_keys=[customer_id], back_populates="bookings_as_customer")
    driver = relationship("User", foreign_keys=[driver_id], back_populates="bookings_as_driver")
    trip = relationship("Trip", back_populates="booking", uselist=False)
    payments = relationship("Payment", back_populates="booking")
