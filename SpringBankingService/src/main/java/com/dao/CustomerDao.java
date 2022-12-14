package com.dao;

import java.util.List;

import com.bean.Customer;

public interface CustomerDao {
	void save(Customer customer);
	void update(Customer customer);
	void deactivate(int id);
	void activate(int id);
	Customer getCustomerById(int id);
	Customer getCustomerByIdentityNum(String identityNumber);
	Customer getCustomerByCredentials(String username, String password);
	Customer getCustomerForRegister(String identityNumber, String name, String email);
	List<Customer> getCustomers();
	List<Customer> getCustomers(String status);
}
