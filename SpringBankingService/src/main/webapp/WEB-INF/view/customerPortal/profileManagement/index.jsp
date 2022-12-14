<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<div class="container my-4">
	<div class="my-auto">
		<h3>Manage Profile</h3>
	</div>
	<div class="card card-shadow my-5">
		<div class="card-body p-4">
			<c:url var="url" value="/customer/profile-management/save" />
			<form:form name="profile" modelAttribute="user" action="${url}" method="post" class="needs-validation" novalidate="true" onsubmit="submitForm()">
				<form:input type="hidden" path="id" />
				<form:input type="hidden" path="password" />
				<form:input type="hidden" path="status" />
				<ul class="list-group list-group-flush">
					<li class="list-group-item px-4 py-3"><spring:bind path="username">
							<div class="row align-items-center">
								<div class="col-3 text-secondary">
									<i class="fa-solid fa-user fa-xl fa-fw"></i> <span class="fw-bold mx-2">Username</span>
								</div>
								<div class="col-auto">
									<form:input path="username" class="form-control border-0 ps-0" readonly="true" />
								</div>
							</div>
						</spring:bind>
					</li>
					<li class="list-group-item px-4 py-3">
						<spring:bind path="name">
							<div class="row align-items-center">
								<div class="col-3 text-secondary">
									<i class="fa-solid fa-signature fa-xl fa-fw"></i> <span class="fw-bold mx-2">Name</span>
								</div>
								<div class="col-auto">
									<form:input path="name" class="form-control ${status.error ? 'is-invalid' : ''}"  required="required"/>
									<div class="invalid-feedback">
										<c:choose>
											<c:when test="${status.error}">
												<form:errors path="name" />
											</c:when>
											<c:otherwise>
												Please enter name.
											</c:otherwise>
										</c:choose>
									</div>
								</div>
							</div>
						</spring:bind>
					</li>
					<li class="list-group-item px-4 py-3">
						<spring:bind path="email">
							<div class="row align-items-center">
								<div class="col-3 text-secondary">
									<i class="fa-solid fa-envelope fa-xl fa-fw"></i> <span class="fw-bold mx-2">Email</span>
								</div>
								<div class="col-auto">
									<form:input type="email" path="email" class="form-control ${status.error ? 'is-invalid' : ''}" required="required" />
									<div class="invalid-feedback">
										<c:choose>
											<c:when test="${status.error}">
												<form:errors path="email" />
											</c:when>
											<c:otherwise>
												Please enter email.
											</c:otherwise>
										</c:choose>
										
									</div>
								</div>
							</div>
						</spring:bind>
					</li>
					<li class="list-group-item px-4 py-3">
						<spring:bind path="contactNo">
							<div class="row align-items-center">
								<div class="col-3 text-secondary">
									<i class="fa-solid fa-phone fa-xl fa-fw"></i> <span class="fw-bold mx-2">Contact Number</span>
								</div>
								<div class="col-auto">
									<form:input id="phone" type="tel" path="contactNo" class="form-control ${status.error ? 'is-invalid' : ''}" />
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
							</div>
						</spring:bind>
					</li>
					<li class="list-group-item px-4 py-3">
						<spring:bind path="gender">
							<div class="row align-items-center">
								<div class="col-3 text-secondary">
									<i class="fa-solid fa-venus-mars fa-xl fa-fw"></i> <span class="fw-bold mx-2">Gender</span>
								</div>
								<div class="col-auto">
									<form:select path="gender" class="form-select ${status.error ? 'is-invalid' : ''}" required="required">
										<form:option value="m">Male</form:option>
										<form:option value="f">Female</form:option>
									</form:select>
									<div class="invalid-feedback">
										<c:choose>
											<c:when test="${status.error}">
												<form:errors path="gender" />
											</c:when>
											<c:otherwise>
												Please select gender.
											</c:otherwise>
										</c:choose>
									</div>
								</div>
							</div>
						</spring:bind>
					</li>
					<li class="list-group-item px-4 py-3">
						<div class="row align-items-center">
							<div class="col-3 text-secondary">
								<i class="fa-solid fa-lock fa-xl fa-fw"></i> <span class="fw-bold mx-2">Password</span>
							</div>
							<div class="col-auto">
								<button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#changePassModal">Change</button>
							</div>
						</div>
					</li>
					<li class="list-group-item px-4 py-3">
						<button type="submit" class="btn btn-danger float-end">Save Profile</button>
					</li>
				</ul>
			</form:form>
		</div>
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
<jsp:include page="./changePassword.jsp" />
<c:if test="${not empty msg}">
	<script>
		// Message Toast
		let msgToast = document.getElementById("msgToast");
		let msgBsToast = new bootstrap.Toast(msgToast);
		msgBsToast.show();
	</script>
	<c:remove scope="session" var="msg"/>
</c:if>
<c:if test="${not empty changePassMsg}">
	<script>
		let changePassModal = new bootstrap.Modal('#changePassModal');
		changePassModal.show();
	</script>
	<c:remove var="changePassMsg"/>
</c:if>
<script>
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