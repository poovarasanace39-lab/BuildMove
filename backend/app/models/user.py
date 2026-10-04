from sqlalchemy import Column, String, Boolean, DateTime, Enum as SQLEnum
from sqlalchemy.orm import relationship
import enum
from datetime import datetime
import uuid
from ..core.database import Base

class UserRoleEnum(str, enum.Enum):
    customer = "customer"
    driver = "driver"
    admin = "admin"

class User(Base):
    __tablename__ = "users"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    phone = Column(String(15), unique=True, index=True, nullable=False)
    name = Column(String(100), nullable=True)
    email = Column(String(120), nullable=True)
    role = Column(SQLEnum(UserRoleEnum), default=UserRoleEnum.customer, nullable=False)
    is_verified = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relationships
    driver_profile = relationship("DriverProfile", back_populates="user", uselist=False)
    bookings_as_customer = relationship("Booking", back_populates="customer", foreign_keys="[Booking.customer_id]")
    bookings_as_driver = relationship("Booking", back_populates="driver", foreign_keys="[Booking.driver_id]")
