from sqlalchemy import Column, String, Float, ForeignKey, DateTime, Enum as SQLEnum
from sqlalchemy.orm import relationship
import enum
from datetime import datetime
import uuid
from ..core.database import Base

class PaymentStatusEnum(str, enum.Enum):
    pending = "pending"
    processing = "processing"
    completed = "completed"
    failed = "failed"
    refunded = "refunded"

class Payment(Base):
    __tablename__ = "payments"

    id = Column(String, primary_key=True, default=lambda: f"PAY-{uuid.uuid4().hex[:10]}")
    booking_id = Column(String, ForeignKey("bookings.id"), nullable=False)
    amount = Column(Float, nullable=False)
    status = Column(SQLEnum(PaymentStatusEnum), default=PaymentStatusEnum.pending, nullable=False)
    method = Column(String(50), default="razorpay")
    razorpay_order_id = Column(String(100), nullable=True)
    razorpay_payment_id = Column(String(100), nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    booking = relationship("Booking", back_populates="payments")
