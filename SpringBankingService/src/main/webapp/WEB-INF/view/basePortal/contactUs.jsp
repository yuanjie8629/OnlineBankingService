<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- Carousel -->
<div class="row m-0">
	<div class="carousel p-0">
		<div class="carousel-item active" style="height: 300px;">
			<div class="container">
				<div class="carousel-caption carousel-caption-middle text-dark">
					<h1>Contact Us</h1>
				</div>
			</div>
			<img src="resources/images/basePortal/contactUs/ContactUsBackground.jpg" alt="contactUs" height="300">
		</div>
	</div>
</div>
<div class="container my-5">
	<h3 class="mb-3">Our Headquarters</h3>
	<iframe class="headquaters-map"
		src="https://maps.google.com/maps?q=singapore%20raffles%20city%20tower&t=&z=15&ie=UTF8&iwloc=&output=embed"></iframe>
</div>
<div class="container my-5">
	<h3>We Value Your Feedback</h3>
	<p>We're committed to ensure our products and services meet your expectations and we value your feedback regarding
		our performance.</p>
	<p>If you would like to compliment members of our team, or you have suggestion as to how we can do better, please
		tell us. Perhaps you are not happy, we want you to let us know.</p>
</div>
<div class="container-fluid p-5" style="background-color: #fcd2d2;">
	<div class="container w-50">
		<h3 class="text-center mb-5">We'd like to hear from you</h3>
		<form:form name="contactUs" modelAttribute="feedback" action="contact-us" method="post"
			class="row g-3 needs-validation" novalidate="true" onsubmit="submitForm()">
			<spring:bind path="name">
				<div class="col-md-6">
					<label for="name" class="form-label">Full Name</label>
					<form:input class="form-control${status.error ? ' is-invalid' : ''}" path="name" placeholder="Enter your full name"
						required="required" />
					<div class="invalid-feedback">
						<c:choose>
							<c:when test="${status.error}">
								<form:errors path="name" />
							</c:when>
							<c:otherwise>
								Please enter your full name.
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</spring:bind>
			<spring:bind path="contactNo">
				<div class="col-12 col-md-6">
					<label class="form-label" for="contactNum">Contact Number</label>
					<form:input id="phone" class="step-1 form-control${status.error ? ' is-invalid' : ''}" type="tel" path="contactNo"
						required="required" />
					<div id="phoneNumInvalid" class="invalid-feedback">
						<c:choose>
							<c:when test="${status.error}">
								<form:errors path="contactNo" />
							</c:when>
							<c:otherwise>
								Please enter valid phone number.
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</spring:bind>
			<spring:bind path="type">
				<div class="col-md-6">
					<label for="type" class="form-label">Type of Feedback</label>
					<form:select class="form-select${status.error ? ' is-invalid' : ''}" path="type" required="required">
						<form:option value="Enquiry">Enquiry</form:option>
						<form:option value="Suggestion">Suggestion</form:option>
						<form:option value="Complaint">Complaint</form:option>
						<form:option value="Others">Others</form:option>
					</form:select>
					<div class="invalid-feedback">
						<c:choose>
							<c:when test="${status.error}">
								<form:errors path="type" />
							</c:when>
							<c:otherwise>
								Please select the type of your feedback.
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</spring:bind>
			<spring:bind path="email">
				<div class="col-md-6">
					<label for="email" class="form-label">Email Address</label>
					<form:input class="form-control${status.error ? ' is-invalid' : ''}" path="email" type="email"
						placeholder="Enter your email address" required="required" />
					<div class="invalid-feedback">
						<c:choose>
							<c:when test="${status.error}">
								<form:errors path="email" />
							</c:when>
							<c:otherwise>
								Please enter valid email address.
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</spring:bind>
			<spring:bind path="message">
				<div class="col-12">
					<label for="message" class="form-label">Message</label>
					<form:textarea class="form-control${status.error ? ' is-invalid' : ''}" path="message" rows="5"
						placeholder="Please type your questions or feedback here" required="required"></form:textarea>
					<div class="invalid-feedback">
						<c:choose>
							<c:when test="${status.error}">
								<form:errors path="message" />
							</c:when>
							<c:otherwise>
							Please enter your message to us.
						</c:otherwise>
						</c:choose>
					</div>
				</div>
			</spring:bind>
			<div class="col-12 form-check">
				<input class="form-check-input" type="checkbox" required /> <label for="confirm" class="form-check-label"
					style="text-align: justify;"> I acknowledge that I have read and understand the online Privacy Policy and
					hereby consent to the OBS Bank Ltd using the information I have provided for purpose of contacting me/addressing my
					request / enquiry / complaint / feedback, etc. </label>
				<div class="invalid-feedback">Please accept the terms and conditions.</div>
			</div>
			<div class="col-12">
				<button type="submit" class="btn btn-danger mb-3 px-5 py-2">Submit</button>
			</div>
		</form:form>
	</div>
</div>
<div class="toast-container position-fixed bottom-0 end-0 p-3">
	<div id="msgToast" class="toast text-bg-danger" role="alert" aria-live="assertive" aria-atomic="true">
		<div class="d-flex align-items-center p-2">
			<div class="toast-body">
				<c:out value="${msg}" />
			</div>
		</div>
	</div>
</div>
<c:if test="${not empty msg}">
	<script>
		// Message Toast
		let msgToast = document.getElementById("msgToast");
		let msgBsToast = new bootstrap.Toast(msgToast);
		msgBsToast.show();
	</script>
	<c:remove var="msg" />
</c:if>
<script>
	(() => {
	  'use strict'

	  // Fetch all the forms we want to apply custom Bootstrap validation styles to
	  const forms = document.querySelectorAll('.needs-validation')

	  // Loop over them and prevent submission
	  Array.from(forms).forEach(form => {
	    form.addEventListener('submit', event => {
	      if (!form.checkValidity()) {
	        event.preventDefault()
	        event.stopPropagation()
	      }

	      form.classList.add('was-validated')
	    }, false)
	  })
	})()
	
	// Script to initialize international phone input
	let phoneInput = document.getElementById("phone");
	let phoneInputErr = document.getElementById("phoneNumInvalid");
	let intlPhoneInput = intlTelInput(phoneInput, {
		utilsScript: "https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.8/js/utils.js",
		initialCountry: "auto",
		// Check user's ip location
		geoIpLookup: function(success, failure) {
		    $.get("https://ipinfo.io?token=e8f08eaac8b60c", function() {}, "jsonp").always(function(resp) {
		      var countryCode = (resp && resp.country) ? resp.country : "sg";
		      success(countryCode);
		    });
		},
   	});
	
	// Phone Number Validation
	function reset() {
		phoneInput.classList.remove("is-invalid");
		phoneInputErr.classList.remove("d-block");
	};
	
	function validatePhoneNum() {
		reset();
		if (phoneInput.value.trim() && intlPhoneInput.isValidNumber()) {
			phoneInput.classList.remove("is-invalid");
			phoneInput.setCustomValidity("");
			phoneInputErr.classList.remove("d-block");
			return true;
		}
		phoneInput.classList.add("is-invalid");
    	phoneInput.setCustomValidity("invalidPhoneNum");
    	phoneInputErr.classList.add("d-block");
		return false;
	}
	
	phoneInput.addEventListener('blur', validatePhoneNum);
	phoneInput.addEventListener('change', reset);
	phoneInput.addEventListener('keyup', reset);
	
	function submitForm() {
		validatePhoneNum();
		// Add country code before the phone number
		phoneInput.value = intlPhoneInput.getNumber();
		return true;
	}
</script>