from sqlalchemy import Column, String, Boolean, Float, ForeignKey, DateTime, Enum as SQLEnum
from sqlalchemy.orm import relationship
import enum
from datetime import datetime
import uuid
from ..core.database import Base

class VehicleTypeEnum(str, enum.Enum):
    tata_ace = "tata_ace"
    pickup_8ft = "pickup_8ft"
    eeco = "eeco"
    tipper_6wheeler = "tipper_6wheeler"
    tipper_10wheeler = "tipper_10wheeler"
    tractor_trolley = "tractor_trolley"

class DocumentStatusEnum(str, enum.Enum):
    pending = "pending"
    approved = "approved"
    rejected = "rejected"

class Vehicle(Base):
    __tablename__ = "vehicles"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    driver_id = Column(String, ForeignKey("driver_profiles.id"), nullable=False)
    type = Column(SQLEnum(VehicleTypeEnum), nullable=False)
    model_name = Column(String(80), nullable=False)
    plate_number = Column(String(30), unique=True, nullable=False)
    capacity_tons = Column(Float, nullable=False)
    is_available = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    driver = relationship("DriverProfile", back_populates="vehicles")
    documents = relationship("VehicleDocument", back_populates="vehicle")

class VehicleDocument(Base):
    __tablename__ = "vehicle_documents"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    vehicle_id = Column(String, ForeignKey("vehicles.id"), nullable=False)
    document_type = Column(String(50), nullable=False)  # RC, Insurance, Permit, Fitness
    document_url = Column(String(255), nullable=False)
    status = Column(SQLEnum(DocumentStatusEnum), default=DocumentStatusEnum.pending)
    verified_at = Column(DateTime, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    vehicle = relationship("Vehicle", back_populates="documents")
