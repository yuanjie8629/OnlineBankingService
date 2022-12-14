<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<div class="container my-4">
	<div class="row justify-content-between">
		<div class="col-auto my-auto">
			<h3>Manage Cards</h3>
		</div>
		<div class="col-auto my-auto">
			<a href="<c:url value="/admin/card-management/add" />" role="button" class="btn btn-danger px-3 py-2">Add Card</a>
		</div>
	</div>
	<form name="filterCard" method="get" action="<c:url value="/admin/card-management" />" onsubmit="validateForm(this)">
		<input type="hidden" name="type">
		<div class="card card-shadow my-4">
			<div class="card-body p-4">
				<div class="card-body p-4">
					<h4 class="mb-4">Card List</h4>
					<div class="row justify-content-between align-items-center g-3 mt-2 mb-5">
						<div class="col-auto">
							<!-- Card Type Tabs -->
							<nav id="card-type" class="nav nav-pills nav-tab-category fw-bold">
								<a id="credit" class="nav-link active px-3 py-2 me-4" href="">Credit Card</a>
							</nav>
						</div>
						<div class="col-auto">
							<div class="form-check">
								<input class="form-check-input" type="checkbox" name="showDeleted" onchange="submitForm()" /> <label
									class="form-check-label" for="showDeleted">Show Deleted Cards</label>
							</div>
						</div>
					</div>
					<!-- Card List -->
					<table id="cardTable" class="table table-hover">
						<thead>
							<tr>
								<th scope="col">ID</th>
								<th scope="col" style="width: 15%;">Thumbnail</th>
								<th scope="col">Title</th>
								<th scope="col" style="width: 20%;">Description</th>
								<th scope="col">Min Income</th>
								<th scope="col">Interest Rate</th>
								<th scope="col">Annual Fee</th>
								<th scope="col" style="width: 10%;">Action</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="card" items="${cardList}">
								<tr>
									<th scope="row"><c:out value="${card.id}" /></th>
									<td style="max-height: 50px;"><img src="data:image/png;base64,${card.getBase64Thumbnail()}"
										alt="cardthumbnail-${card.id}" class="img-fluid" /></td>
									<td><c:out value="${card.title}" /></td>
									<td><c:out value="${card.description}" /></td>
									<td><fmt:formatNumber value="${card.minIncome}" type="currency" currencyCode="SGD" /></td>
									<td><fmt:formatNumber value="${card.interestRate}" type="percent" minFractionDigits="2" /> p.a.</td>
									<td><fmt:formatNumber value="${card.annualFee}" type="currency" currencyCode="SGD" /></td>
									<td>
										<div class="row g-3">
											<div class="col-12">
												<a href="<c:url value="/admin/card-management/update/${card.id}" />" role="button"
													class="btn btn-outline-primary btn-sm w-100"> <i class="fa-solid fa-pen-to-square me-2"></i> Update
												</a>
											</div>
											<div class="col-12">
												<c:choose>
													<c:when test="${!card.isDeleted()}">
														<button type="button" class="btn btn-outline-danger btn-sm w-100" data-bs-toggle="modal"
															data-bs-target="#deleteCardModal" data-bs-id="${card.id}">
															<i class="fa-solid fa-trash me-2"></i>Delete
														</button>
													</c:when>
													<c:otherwise>
														<button type="button" class="btn btn-outline-success btn-sm w-100" data-bs-toggle="modal"
															data-bs-target="#restoreCardModal" data-bs-id="${card.id}">
															<i class="fa-solid fa-trash-can-arrow-up me-2"></i>Restore
														</button>
													</c:otherwise>
												</c:choose>
											</div>
										</div>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</form>
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
<jsp:include page="./deleteCard.jsp" />
<jsp:include page="./restoreCard.jsp" />
<c:if test="${not empty msg}">
	<script>
		// Message Toast
		let msgToast = document.getElementById("msgToast");
		let msgBsToast = new bootstrap.Toast(msgToast);
		msgBsToast.show();
	</script>
	<c:remove scope="session" var="msg"/>
</c:if>
<script>
	$(document).ready(function() {
		$('#cardTable').DataTable({
			columnDefs: [
				{ orderable: false, targets: -1 }
			],
			dom: '<"container-fluid"<"row mb-3"<"col-auto"B>><"row"<"col-auto"l><"col"f>>>rtip',
			lengthMenu: [10,25,50,100],
			buttons: [
	            {
	                extend: 'excelHtml5',
	                text: 'Export Excel',
	                exportOptions: {
	                	columns: [ 0, 2, 3, 4, 5, 6 ]
	                }
	            },
	            {
	                extend: 'pdfHtml5',
	                text: 'Export PDF',
	                exportOptions: {
	                	columns: [ 0, 2, 3, 4, 5, 6 ]
	                },
	            },
	            {
	                extend: 'print',
	                text: 'Print',
	                exportOptions: {
	                	columns: [ 0, 2, 3, 4, 5, 6 ]
	                },
	            }
	        ],
		});
	});
	
	let queryParams = new URLSearchParams(window.location.search);
	let filterCardForm = document.forms["filterCard"];
	/* Script to tick the showDeleted checkbox according to url query*/
	let showDeleted = queryParams.get("showDeleted");
	if (showDeleted != null) {
		filterCardForm['showDeleted'].checked = true;
	}
	
	/* Function to remove empty query from the search form  */
	function validateForm(form) {
		for (var element of form.elements){
			if (element.value == "") {
				element.disabled = true;
			}
		}
	}

	function submitForm() {
		let form = document.forms["filterCard"];
		validateForm(form);
		form.submit();
	}
</script>