package com.controller;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bean.AccountTransaction;
import com.bean.CreditCardPayment;
import com.bean.CustAccount;
import com.bean.CustCreditCard;
import com.bean.CustLoan;
import com.bean.Customer;
import com.bean.LoanPayment;
import com.dao.AccountTransactionDao;
import com.dao.CreditCardPaymentDao;
import com.dao.CustAccDao;
import com.dao.CustCreditCardDao;
import com.dao.CustLoanDao;
import com.dao.LoanPaymentDao;
import com.service.MailService;

@Controller
@RequestMapping("/customer/payment")
public class CustPaymentController {
	
	@Autowired
	CustAccDao custAccDao;

	@Autowired
	CustCreditCardDao custCreditCardDao;
	
	@Autowired
	CreditCardPaymentDao creditCardPaymentDao;
	
	@Autowired
	CustLoanDao custLoanDao;
	
	@Autowired
	LoanPaymentDao loanPaymentDao;
	
	@Autowired
	AccountTransactionDao accTransactionDao;
	
	@Autowired
	MailService mailService;
	
	@Autowired
	HttpSession session;
	
	@RequestMapping(value = "")
	public String payment() {
		return "cust-payment";
	}

	@RequestMapping(value = "/credit-card")
	public String creditCardPayment(@PathVariable(required=false) Integer id, Model m, RedirectAttributes ra) {
		Customer cust = (Customer) session.getAttribute("user");
		List<CustCreditCard> custCreditCardList = custCreditCardDao.getCustCreditCardsByCust(cust);
		if (!custCreditCardList.isEmpty()) {
			custCreditCardList.forEach(card -> {
				card.setCardNum(String.join("", Collections.nCopies(3, "**** ")) + card.getCardNum().split(" ")[3]);
				// Remove card pin from all card for safety purpose
				card.setPin("");
			});
			CustCreditCard selectedCreditCard;
			if (id != null) {
				List<CustCreditCard> filteredCard = custCreditCardList.stream().filter(card -> card.getId() == id).collect(Collectors.toList());
				if (filteredCard.isEmpty()) {
					ra.addAttribute("msg", "The credit card selected is not found...");
					return "redirect:/customer/payment";
				} else {
					selectedCreditCard = filteredCard.get(0);
				}
			} else {
				selectedCreditCard = custCreditCardList.get(0);
			}
			m.addAttribute("selectedCreditCard", selectedCreditCard);
			m.addAttribute("payments", creditCardPaymentDao.getPayments(selectedCreditCard));
		}
		m.addAttribute("custCreditCardList", custCreditCardList);
		return "cust-payment-credit-card";
	}
	
	@RequestMapping(value = "/credit-card/pay/{id}")
	public String payForCreditCard(@PathVariable int id, Model m, RedirectAttributes ra) {
		Customer cust = (Customer) session.getAttribute("user");
		List<CustAccount> custAccList = custAccDao.getCustAccountsByCust(cust);
		if (!custAccList.isEmpty()) {
			CreditCardPayment creditCardPayment = creditCardPaymentDao.getPaymentById(id);
			creditCardPayment.getCreditCard().setCardNum(String.join("", Collections.nCopies(3, "**** ")) + creditCardPayment.getCreditCard().getCardNum().split(" ")[3]);
			creditCardPayment.getCreditCard().setPin(null);
			m.addAttribute("creditCardPayment", creditCardPayment);
			m.addAttribute("custAccList", custAccList);
			return "cust-payment-credit-card-pay";
		} else {
			ra.addFlashAttribute("noAcc", true);
			return "redirect:/customer/payment/credit-card";
		}
	}
	
	@RequestMapping(value = "/credit-card/pay/save", method=RequestMethod.POST)
	@Transactional
	public String payForCreditCard(@RequestParam int id, @RequestParam String accNum, Model m, RedirectAttributes ra) {
		CustAccount custAcc = custAccDao.getCustAccountById(accNum);
		CreditCardPayment creditCardPayment = creditCardPaymentDao.getPaymentById(id);
		double totalAmount = creditCardPayment.getAmount() + creditCardPayment.getInterestCharged() + creditCardPayment.getAdditionalCharge();
		if (custAcc.getAvailBal() > totalAmount) {
			String encryptedCardNum = String.join("", Collections.nCopies(3, "**** ")) + creditCardPayment.getCreditCard().getCardNum().split(" ")[3];
			
			// Update new account balance
			custAcc.setAvailBal(custAcc.getAvailBal() - totalAmount);
			custAcc.setCurBal(custAcc.getCurBal() - totalAmount);
			custAccDao.update(custAcc);
			
			// Add new account transaction
			AccountTransaction accTrans = new AccountTransaction();
			accTrans.setType("withdraw");
			accTrans.setAccount(custAcc);
			accTrans.setAmount(totalAmount);
			accTrans.setDescription(creditCardPayment.getDescription());
			accTrans.setReference("Credit Card Payment to " + encryptedCardNum);
			accTrans.setBalance(custAcc.getAvailBal());
			accTrans.setStatus("posted");
			accTransactionDao.save(accTrans);
			
			// Reset credit card's credit limit if the pay for is last month's payment
			CustCreditCard custCreditCard = creditCardPayment.getCreditCard();
			DateTimeFormatter df = DateTimeFormatter.ofPattern("yyyyMMdd");
			LocalDate paymentMonth = LocalDate.parse(creditCardPayment.getPaymentMonth() + "01", df);
			LocalDate lastMonth = LocalDate.now().minusMonths(1);
			if (lastMonth.getMonthValue() == paymentMonth.getMonthValue() && lastMonth.getYear() == paymentMonth.getYear()) {
				custCreditCard.setBalance(custCreditCard.getCreditLimit());
				custCreditCardDao.update(custCreditCard);
			}
			
			// Update payment record
			creditCardPayment.setStatus("Completed");
			creditCardPayment.setPaidDate(LocalDateTime.now());
			creditCardPaymentDao.update(creditCardPayment);
			
			// Send Email
			DateTimeFormatter emailDf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
			String subject = "OBS Credit Card Payment";
			String msg = "Dear " + custCreditCard.getCustomer().getName() + ",\n"
							+ "You have successfully paid your " + custCreditCard.getCreditCard().getTitle() + " (Card No. " + encryptedCardNum + ").\n"
							+ "Below is the payment details:\n\n"
							+ "Payment Month: " + creditCardPayment.getPaymentMonth() + "\n"
							+ "Payment Description: " + creditCardPayment.getDescription() + "\n"
							+ "Total Amount: " + totalAmount + " SGD\n"
							+ "Paid Date: " + creditCardPayment.getPaidDate().format(emailDf)
							+ "\n\nThank you for choosing OBS Bank. We wish you a great day!"
							+ "\n\nCheers,\nOBS Team";
			mailService.sendMail(custCreditCard.getCustomer().getEmail(), subject, msg);
			
			ra.addFlashAttribute("msg", "You have successfully pay the credit card with card number ending with " + custCreditCard.getCardNum().split(" ")[3]);
		} else {
			ra.addFlashAttribute("msg", "Not enough account balance to pay for the credit card...");
		}
		return "redirect:/customer/payment/credit-card";
	}
	
	@RequestMapping(value = "/loan")
	public String loanPayment(@PathVariable(required=false) String id, Model m, RedirectAttributes ra) {
		Customer cust = (Customer) session.getAttribute("user");
		List<CustLoan> custLoanList = custLoanDao.getCustLoansByCust(cust);
		if (!custLoanList.isEmpty()) {
			CustLoan selectedLoan;
			if (id != null) {
				List<CustLoan> filteredLoan = custLoanList.stream().filter(loan -> loan.getId().equals(id)).collect(Collectors.toList());
				if (filteredLoan.isEmpty()) {
					ra.addAttribute("msg", "The loan selected is not found...");
					return "redirect:/customer/payment";
				} else {
					selectedLoan = filteredLoan.get(0);
				}
			} else {
				selectedLoan = custLoanList.get(0);
			}
			m.addAttribute("selectedLoan", selectedLoan);
			m.addAttribute("payments", loanPaymentDao.getPayments(selectedLoan));
		}
		m.addAttribute("custLoanList", custLoanList);
		return "cust-payment-loan";
	}
	
	@RequestMapping(value = "/loan/pay/{id}")
	public String payForLoan(@PathVariable int id, Model m, RedirectAttributes ra) {
		Customer cust = (Customer) session.getAttribute("user");
		List<CustAccount> custAccList = custAccDao.getCustAccountsByCust(cust);
		if (!custAccList.isEmpty()) {
			LoanPayment loanPayment = loanPaymentDao.getPaymentById(id);
			m.addAttribute("loanPayment", loanPayment);
			m.addAttribute("custAccList", custAccList);
			return "cust-payment-loan-pay";
		} else {
			ra.addFlashAttribute("noAcc", true);
			return "redirect:/customer/payment/loan";
		}
	}
	
	@RequestMapping(value = "/loan/pay/save", method=RequestMethod.POST)
	@Transactional
	public String payForLoan(@RequestParam int id, @RequestParam String accNum, Model m, RedirectAttributes ra) {
		CustAccount custAcc = custAccDao.getCustAccountById(accNum);
		LoanPayment loanPayment = loanPaymentDao.getPaymentById(id);
		double totalAmount = loanPayment.getAmount() + loanPayment.getAdditionalCharge();
		if (custAcc.getAvailBal() > totalAmount) {			
			// Update new account balance
			custAcc.setAvailBal(custAcc.getAvailBal() - loanPayment.getAmount());
			custAcc.setCurBal(custAcc.getCurBal() - loanPayment.getAmount());
			custAccDao.update(custAcc);
			
			CustLoan custLoan = loanPayment.getLoan();
			
			// Encrypt loan ID after 5th digit
			String encryptedLoanID = custLoan.getId().substring(0, 5) + String.join("", Collections.nCopies(custLoan.getId().length() - 5, "*"));
			// Add new account transaction
			AccountTransaction accTrans = new AccountTransaction();
			accTrans.setType("withdraw");
			accTrans.setAccount(custAcc);
			accTrans.setAmount(totalAmount);
			accTrans.setDescription(loanPayment.getDescription());
			accTrans.setReference("Loan Payment to " + encryptedLoanID);
			accTrans.setBalance(custAcc.getAvailBal());
			accTrans.setStatus("posted");
			accTransactionDao.save(accTrans);
			
			// Update payment record
			loanPayment.setStatus("Completed");
			loanPayment.setPaidDate(LocalDateTime.now());
			loanPaymentDao.update(loanPayment);
			
			// Send Email
			DateTimeFormatter emailDf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
			String subject = "OBS Loan Payment";
			String msg = "Dear " + custLoan.getCustomer().getName() + ",\n"
							+ "You have successfully paid your " + custLoan.getLoan().getTitle() + " (ID " + custLoan.getId() + ").\n"
							+ "Below is the payment details:\n\n"
							+ "Payment Month: " + loanPayment.getPaymentMonth() + "\n"
							+ "Payment Description: " + loanPayment.getDescription() + "\n"
							+ "Total Amount: " + totalAmount + " SGD\n"
							+ "Paid Date: " + loanPayment.getPaidDate().format(emailDf)
							+ "\n\nThank you for choosing OBS Bank. We wish you a great day!"
							+ "\n\nCheers,\nOBS Team";
			mailService.sendMail(custLoan.getCustomer().getEmail(), subject, msg);
			
			ra.addFlashAttribute("msg", "You have successfully pay the loan with ID " + custLoan.getId());
		} else {
			ra.addFlashAttribute("msg", "Not enough account balance to pay for the loan ...");
		}
		return "redirect:/customer/payment/loan";
	}
}
