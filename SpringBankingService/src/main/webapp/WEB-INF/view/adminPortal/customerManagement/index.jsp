<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<div class="container my-4">
	<div class="row justify-content-between align-items-center my-auto">
		<div class="col-auto">
			<h3>Manage Customers</h3>
		</div>
		<div class="col-auto">
			<div class="row">
				<div class="col-auto">
					<a href="<c:url value="/admin/customer-management/account" />" role="button" class="btn btn-danger px-3 py-2">
						Customer Account
					</a>
				</div>
				<div class="col-auto">
					<a href="<c:url value="/admin/customer-management/credit-card" />" role="button" class="btn btn-danger px-3 py-2">
						Customer Credit Card
					</a>
				</div>
				<div class="col-auto">
					<a href="<c:url value="/admin/customer-management/loan" />" role="button" class="btn btn-danger px-3 py-2">
						Customer Loan
					</a>
				</div>
			</div>
		</div>
	</div>
	<div class="card card-shadow my-5">
		<div class="card-body p-4">
			<h4 class="mb-4">Customer List</h4>
			<div class="row justify-content-between align-items-center g-3 mt-2 mb-5">
				<div class="col-auto">
					<!-- Customer Status Tabs -->
					<nav id="cust-status" class="nav nav-pills nav-tab-category fw-bold">
						<a id="all" class="nav-link px-3 py-2 me-4 active" href="customer-management">All</a> <a id="active"
							class="nav-link px-3 py-2 me-4" href="customer-management?status=active">Active</a> <a id="inactive"
							class="nav-link px-3 py-2 me-4" href="customer-management?status=inactive">Inactive</a>
					</nav>
				</div>
			</div>
			<!-- Customer List -->
			<table id="custTable" class="table table-hover">
				<thead>
					<tr>
						<th scope="col">ID</th>
						<th scope="col">Name</th>
						<th scope="col">Email</th>
						<th scope="col">Contact No.</th>
						<th scope="col">Identity No.</th>
						<th scope="col">Birth Date</th>
						<th scope="col">Occupation</th>
						<th scope="col">Status</th>
						<th scope="col" style="width: 10%;">Action</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="cust" items="${custList}">
						<c:choose>
							<c:when test="${fn:toLowerCase(cust.status) == 'active'}">
								<c:set var="status" value="success" />
							</c:when>
							<c:when test="${fn:toLowerCase(cust.status) == 'inactive'}">
								<c:set var="status" value="danger" />
							</c:when>
							<c:otherwise>
								<c:set var="status" value="secondary" />
							</c:otherwise>
						</c:choose>
						<tr>
							<th scope="row"><c:out value="${cust.id}" /></th>
							<td><c:out value="${cust.name}" /></td>
							<td><c:out value="${cust.email}" /></td>
							<td><c:out value="${cust.contactNo}" /></td>
							<td><c:out value="${cust.identityNumber}" /></td>
							<td><c:out value="${cust.birthdate}" /></td>
							<td><c:out value="${cust.occupation}" /></td>
							<td><span class="badge text-bg-${status} text-white text-capitalize w-100"><c:out value="${cust.status}" /></span></td>
							<td class="text-center">
								<div class="dropdown-center">
									<i class="fa-solid fa-ellipsis fa-xl menu-ellipsis" data-bs-toggle="dropdown" aria-expanded="false"></i>
									<ul class="dropdown-menu">
										<li><a href="<c:url value="/admin/customer-management/view/${cust.id}" />" class="dropdown-item"
											style="cursor: pointer;"> <i class="fa-solid fa-eye fa-fw me-2"></i>View
										</a></li>
										<li><a href="<c:url value="/admin/customer-management/update/${cust.id}" />" class="dropdown-item"
											style="cursor: pointer;"> <i class="fa-solid fa-pen-to-square fa-fw me-2"></i>Update
										</a></li>
										<li><c:choose>
												<c:when test="${fn:toLowerCase(cust.status) == 'active'}">
													<a class="dropdown-item" style="cursor: pointer;" data-bs-toggle="modal" data-bs-id="${cust.id}"
														data-bs-target="#deactivateCustModal"> <i class="fa-solid fa-circle-xmark fa-fw me-2"></i>Deactivate
													</a>
												</c:when>
												<c:when test="${fn:toLowerCase(cust.status) == 'inactive'}">
													<a class="dropdown-item" style="cursor: pointer;" data-bs-toggle="modal" data-bs-id="${cust.id}"
														data-bs-target="#activateCustModal"> <i class="fa-solid fa-circle-check fa-fw me-2"></i>Activate
													</a>
												</c:when>
											</c:choose></li>
									</ul>
								</div>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</div>
<jsp:include page="./deactivateCustomer.jsp" />
<jsp:include page="./activateCustomer.jsp" />
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
	<c:remove scope="session" var="msg"/>
</c:if>
<script>
	$(document).ready(function() {
		$('#custTable').DataTable({
			order: [[0, 'desc']],
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
	                	columns: [ ':not(:last-child)' ]
	                }
	            },
	            {
	                extend: 'pdfHtml5',
	                text: 'Export PDF',
	                exportOptions: {
	                	columns: [ ':not(:last-child)' ]
	                },
	            },
	            {
	                extend: 'print',
	                text: 'Print',
	                exportOptions: {
	                	columns: [ ':not(:last-child)' ]
	                },
	            }
	        ],
		});
	});

	/* Script to make tab active based on url params */
	let queryParams = new URLSearchParams(window.location.search);
	let custStatus = queryParams.get("status");
	let filterCustForm = document.forms["filterCust"];
	if (custStatus != null) {
		let custStatusList = document.getElementById("cust-status").children;
		for (var i = 0; i < custStatusList.length; i++) {
			if (custStatusList[i].id.toLowerCase() == custStatus.toLowerCase())
				custStatusList[i].className += " active";
			else
				custStatusList[i].className = custStatusList[i].className
						.replace(" active", "");
		}
	}
</script>