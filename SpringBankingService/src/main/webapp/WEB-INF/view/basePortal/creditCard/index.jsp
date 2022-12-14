<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!-- Carousel -->
<div class="row m-0">
	<div class="carousel p-0">
		<div class="carousel-item active" style="height: 300px;">
			<div class="container">
				<div class="carousel-caption carousel-caption-middle">
					<h1>Credit Cards</h1>
				</div>
			</div>
			<img src="resources/images/basePortal/creditCard/CreditCardBackground.jpg" alt="creditCard" height="300">
		</div>
	</div>
</div>
<div class="container my-5">
	<!-- List of Credit Cards Available -->
	<c:choose>
		<c:when test="${not empty cardList}">
			<div class="my-5">
				<div class="row g-4">
					<c:forEach var="card" items="${cardList}">
						<div class="col-12 col-md-6 col-lg-3">
							<div class="card card-hover h-100">
								<div class="card-thumbnail-img p-1">
									<img src="data:image/png;base64,${card.getBase64Thumbnail()}" class="card-img-top img-fluid"
										style="object-fit: contain;" alt="${card.title}">
								</div>
								<div class="card-body pb-0">
									<h5 id="titlePrev" class="card-title">
										<c:out value="${card.title}" />
									</h5>
									<p id="descriptionPrev" class="card-text text-justify">
										<c:out value="${card.description}" />
									</p>
									<table class="table text-justify">
										<tr>
											<td>Min Income</td>
											<td><span id="minIncomePrev"> <fmt:formatNumber value="${card.minIncome}" type="currency"
														currencyCode="SGD" />
											</span></td>
										</tr>
										<tr>
											<td>Interest Rate</td>
											<td><span id="interestRatePrev"> <fmt:formatNumber value="${card.interestRate / 100}"
														type="percent" minFractionDigits="2" />
											</span> p.a.</td>
										</tr>
										<tr>
											<td>Annual Fee</td>
											<td><span id="annualFeePrev"> <fmt:formatNumber value="${card.annualFee}" type="currency"
														currencyCode="SGD" />
											</span></td>
										</tr>
									</table>
								</div>
								<div class="card-footer">
									<button class="btn btn-danger stretched-link w-100 mb-2" data-bs-toggle="modal" data-bs-target="#applyModal"
										data-bs-id="${card.id}">Apply Now</button>
								</div>
							</div>
						</div>
					</c:forEach>
				</div>
			</div>
		</c:when>
		<c:otherwise>
			<div class="p-3 my-5 mx-auto" style="max-width: 400px;">
				<img src="<c:url value="/resources/images/Empty.png" />" class="img-fluid">
			</div>
		</c:otherwise>
	</c:choose>
</div>
<jsp:include page="applyModal.jsp" />
<jsp:include page="../applySuccessModal.jsp" />
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
<c:if test="${not empty refNum}">
	<script>
		// Success Modal
		let applySuccessModal = new bootstrap.Modal('#applySuccessModal');
		applySuccessModal.show();
	</script>
	<c:remove var="refNum" />
</c:if>