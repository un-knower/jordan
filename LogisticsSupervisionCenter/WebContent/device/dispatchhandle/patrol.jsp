<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../../include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="../../include/include.jsp" />
<title><fmt:message key="system.notice.title" /></title>
</head>
<body>
	<%--调度完成通知页面 --%>
	<%@ include file="../../include/tripMsgModal.jsp"%>
	<div class="row">
		<div class="col-md-12 my_news">
			<div class="modal-header">
				<!-- 由于js代码不能直接获取后台的值，可以先将值传到input中，js中用.val()方法取值 -->
				<input type="hidden" class="form-control" id="dispacthed"
					value=${dispacthId}>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title" id="addPatrolModal">
					<fmt:message key="dispatch.sendMsg.toPatrol" />
				</h4>
			</div>

			<div class="modal-body">
				<div>
					<table id="patrolTable" class="table table-bordered table-striped">
					</table>
				</div>
			</div>
			<div class="clearfix"></div>
			<div class="modal-footer margin15">
				<button type="button" class="btn btn-danger" data-dismiss="modal"
					id="sendMsgBtn">
					<fmt:message key="dispatch.push" />
				</button>
				<button type="button" class="btn btn-darch" data-dismiss="modal">
					<fmt:message key="common.button.cancle" />
				</button>
			</div>

		</div>
	</div>
	<%-- <script type="text/javascript" src="${root}/device/dispatchhandle/js/sendMessage.js"></script> --%>
	<script type="text/javascript">
		var $table = $('#patrolTable');
		var dispatched = $("#dispacthed").val();

		/**
		 * 巡逻队列表 
		 */
		$(function() {
			$table.bootstrapTable({
				url : root + "/patrol/dlist.action",
				height : $(window).height() - 300,//固定模态框 的 宽度 
				pagination : true,
				pageSize : 5,
				maintainSelected : true,
				columns : [ {
					checkbox : true
				}, {
					field : 'routeAreaName',
					title : $.i18n.prop('dispatch.belongTo.areaName')
				}, {
					field : 'potralUser',
					title : $.i18n.prop('dispacth.patrol.inCharge')
				}, {
					field : 'createUser',
					title : $.i18n.prop('dispatch.patrol.createUser')
				} ],
			})
		})

		/**
		 * 点击推送按钮推送消息
		 */
		$("#sendMsgBtn")
				.click(
						function() {
							//获取选中的负责人的Id
							var list = $table.bootstrapTable('getSelections'); //获取表的行
							var ids = $.map($table
									.bootstrapTable('getSelections'), function(
									row) {
								return row.potralUser
							});
							var potralUserIds = ids.join(",");
							if(list.length<=0){
								bootbox.alert($.i18n.prop("dispatch.choose.patrol.to.push.message"));
								return;
							}else{
								//推送消息
								var ajaxUrl = "${root}/dispatchSendMsg/sendToPatrol.action?potralUserIds="
									+ potralUserIds
									+ "&dispacthId="
									+ dispatched;
							$.ajax({
										url : ajaxUrl, // 请求url
										type : "post", // 提交方式
										dataType : "json", // 数据类型
										success : function(data) { // 提交成功的回调函数
											if(!needLogin(data)) {
												if (data) {
													bootbox.success($.i18n.prop('dispatch.pushMsg.success'),function(){
														var url = "${root}/dispatch/toList.action"
														window.location.href = url;
													});
												} else {
													bootbox.error($.i18n.prop('dispatch.pushMsg.fail'));
												}
											}
										}
									});
								
							}
							/* window.location.reload();  */
						});
	</script>
</body>
</html>