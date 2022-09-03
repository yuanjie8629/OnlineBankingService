package com.bean;

import java.time.LocalDateTime;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name="credit_card_transaction")
public class CreditCardTransaction {
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int id;
	
	private String type;
	
	private LocalDateTime date;
	
	private String description;
	
	private double amount;
	
	private double balance;
	
	@ManyToOne(targetEntity=CreditCard.class)
	@JoinColumn(name="card_num")
	private CreditCard creditCard;
}
