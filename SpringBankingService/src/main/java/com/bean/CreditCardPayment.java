package com.bean;

import java.time.LocalDate;
import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

import org.hibernate.annotations.CreationTimestamp;
import org.springframework.format.annotation.DateTimeFormat;

@Entity
@Table(name="credit_card_payment")
public class CreditCardPayment {
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int id;
	
	@CreationTimestamp
	private LocalDateTime date;
	
	@Column(name="paid_date")
	private LocalDateTime paidDate;
	
	@Column(name="payment_month")
	private String paymentMonth;
	
	@Column(name="due_date")
	@DateTimeFormat(pattern="yyyy-MM-dd")
	@NotNull(message="Please select payment due date.")
	private LocalDate dueDate;
	
	@NotBlank(message="Please enter payment description.")
	private String description;
	
	@Column(name="interest_charged")
	private double interestCharged;
	
	@Column(name="amount")
	private double amount;
	
	@Column(name="additional_charge")
	private double additionalCharge;
	
	private String status;
	
	@ManyToOne
	@JoinColumn(name="credit_card_id") 
	private CustCreditCard creditCard;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public LocalDateTime getDate() {
		return date;
	}

	public void setDate(LocalDateTime date) {
		this.date = date;
	}

	public LocalDateTime getPaidDate() {
		return paidDate;
	}

	public void setPaidDate(LocalDateTime paidDate) {
		this.paidDate = paidDate;
	}

	public String getPaymentMonth() {
		return paymentMonth;
	}

	public void setPaymentMonth(String paymentMonth) {
		this.paymentMonth = paymentMonth;
	}

	public LocalDate getDueDate() {
		return dueDate;
	}

	public void setDueDate(LocalDate dueDate) {
		this.dueDate = dueDate;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public double getInterestCharged() {
		return interestCharged;
	}

	public void setInterestCharged(double interestCharged) {
		this.interestCharged = interestCharged;
	}

	public double getAmount() {
		return amount;
	}

	public void setAmount(double amount) {
		this.amount = amount;
	}

	public double getAdditionalCharge() {
		return additionalCharge;
	}

	public void setAdditionalCharge(double additionalCharge) {
		this.additionalCharge = additionalCharge;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public CustCreditCard getCreditCard() {
		return creditCard;
	}

	public void setCreditCard(CustCreditCard creditCard) {
		this.creditCard = creditCard;
	}

	public CreditCardPayment() {
	}

	public CreditCardPayment(int id, LocalDateTime date, LocalDateTime paidDate, String paymentMonth,
			@NotNull(message = "Please select payment due date.") LocalDate dueDate,
			@NotBlank(message = "Please enter payment description.") String description, double interestCharged,
			double amount, double additionalCharge, String status, CustCreditCard creditCard) {
		super();
		this.id = id;
		this.date = date;
		this.paidDate = paidDate;
		this.paymentMonth = paymentMonth;
		this.dueDate = dueDate;
		this.description = description;
		this.interestCharged = interestCharged;
		this.amount = amount;
		this.additionalCharge = additionalCharge;
		this.status = status;
		this.creditCard = creditCard;
	}

	@Override
	public String toString() {
		return "CreditCardPayment [id=" + id + ", date=" + date + ", paidDate=" + paidDate + ", paymentMonth="
				+ paymentMonth + ", dueDate=" + dueDate + ", description=" + description + ", interestCharged="
				+ interestCharged + ", amount=" + amount + ", additionalCharge=" + additionalCharge + ", status="
				+ status + ", creditCard=" + creditCard + "]";
	}
}
