<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%> 
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../include/include.jsp" />

<script src="${root}/static/bootstrap-table/bootstrap-table.js"></script>
<title>Performance Analysis</title>
<style type="text/css">
#portForm .input-group-btn>button {
	height: 30px;
}
</style>
</head>
<body>
<%@ include file="../include/left.jsp" %>
<div class="row site">
	<div class="wrapper-content margint95 margin60">
		<div class="col-sm-3 kalb">
			<div class="panel panel-default">
				<div class="panel-heading">
       			  	<div class="pull-right col-sm-8 text-right">
       			  		<form id="portForm" onsubmit="return false;">
        			  		<div class="input-group">
	        			  		<input type="text" class="form-control" id="userName" name="userName" placeholder="<fmt:message key="performance.label.search"/>" onkeyup="treeFilter('tree','userName',this.value)">
        			  			<span class="input-group-btn">
        			  		    	<button class="btn btn-default" type="submit" onclick="treeFilter('tree','userName',document.getElementById('userName').value)">
        			  		       		<span class="glyphicon glyphicon-search" aria-hidden="true"></span>
        			  		       </button>
								</span>
        			  		 </div><!-- /input-group -->
       			  		 </form>
       			  	</div> 	
       			  	<fmt:message key="performance.userHead"/> 			  	
       			  </div>	        			 
       			  <ul id="tree" class="ztree" style="width:260px; overflow:auto;"></ul>
       		</div>
         </div>
         <div class="col-sm-9 right-content">
       		<div class="tab-content m-b">
				<div class="tab-cotent-title"><fmt:message key="performance.analysis.searchTitle" /></div>		    
				<div class="search_form">
					<form id="sForm" name="sForm" action="" onsubmit="return false;" class="form-horizontal row">
						<input type="text" hidden="hidden" name="s_timeFormat" value="yyyy-MM-dd HH:mm">
						<div class="form-group col-md-6">
							<label class="col-sm-3 control-label"><fmt:message key="performance.analysis.logontime" /></label>
							<div class="input-group date col-sm-4" id="s_timeStartDiv">
								<input class="form-control" id='s_timeStart' name='s_timeStart' type="text" value="${pageQuery.filters.timeStart}" readonly>
								<span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
								<!-- <span class="input-group-addon">
			                        <span class="glyphicon glyphicon-calendar"></span>
			                    </span> -->
							</div>
							<label class="col-sm-1 control-label" style="text-align: center;">-</label>
							<div class="input-group date col-sm-4" id="s_timeEndDiv">
								<input class="form-control" id='s_timeEnd' name='s_timeEnd' type="text" value="${pageQuery.filters.timeEnd}" readonly>
								<span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
								<!-- <span class="input-group-addon">
			                        <span class="glyphicon glyphicon-calendar"></span>
			                    </span> -->
							</div>
						</div>
						<div class="form-group">
							<div class="col-sm-offset-9 col-md-3">
								<button class="btn btn-danger" onclick="queryData();" type="submit"><fmt:message key="performance.analysis.searchBtn"/></button>
								<button class="btn btn-darch" type="reset"><fmt:message key="performance.analysis.resetBtn"/></button>
							</div>
						</div>
					</form>
				</div>
			</div>
			<div class="tab-content margint20">
			    <div  class="tab-pane active" id="home">
			    	<div class="row row_three margint20">
	  	            		<div class="col-sm-6  p-r">
	  	            			<div class="panel panel-default">
	  	            			  <div class="panel-heading heading_ico05"><fmt:message key="performance.analysis.onlineTime"/></div>
	  	            			  <div class="panel-body max_heiht" id="time">
	  		            			  
	  	            			  </div>
	  	            			</div>
	  	            		</div>
	  	            		<div class="col-sm-6">
	  	            			<div class="panel panel-default">
	  	            			  <div class="panel-heading heading_ico06"><fmt:message key="performance.analysis.userOpNum"/></div>
	  	            			  <div class="panel-body max_heiht" id="num">
	  	            			  
	  	            			  </div>
	  	            			</div>
	  	            		</div>
			    	 </div>
			    </div>
			 </div>
		 
			 <div class="tab-content margint20">
	         	<div class="tab-cotent-title"><fmt:message key="performance.analysis.data"/></div>		
			    <div  class="tab-pane active" id="home">
			    	<div class="row row_three margint20">
	  	            	<table id="table"></table>
			    	 </div>
			    </div>
			 </div>
         </div>
	</div>
</div>	       

<script type="text/javascript" src="${root}/static/zTree_v3/js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="${root}/static/zTree_v3/js/jquery.ztree.excheck.js"></script>
<script type="text/javascript" src="${root}/static/zTree_v3/js/jquery.ztree.exhide.js"></script>

<script type="text/javascript" src="${root}/static/echarts/echarts.min.js"></script>

<script src="${root}/static/moment/moment-with-locales.min.js"></script>
<script type="text/javascript">
$(function () {
	$('#s_timeStartDiv, #s_timeEndDiv').datetimepicker({
		format:'yyyy-mm-dd hh:ii',
		autoclose: true
	}).on('changeDate', function(ev){
	    var startTime = $('#s_timeStart').val();//获得开始时间
	    $('#s_timeEndDiv').datetimepicker('setStartDate', startTime);//设置结束时间（大于开始时间）
	});
});
function queryData(){
	 var settings = {
        type: "POST",
        url:"${root}/analysis/queryEcharts.action",
        dataType:"json",
        data: $("#sForm").serialize(),
        error: function(XHR,textStatus,errorThrown) {
            alert ("XHR="+XHR+"\ntextStatus="+textStatus+"\nerrorThrown=" + errorThrown);
        },
        success: function(data,textStatus) {
        	if(!needLogin(data)) {
	            arr = data.data;
	            var treeObj = $.fn.zTree.getZTreeObj("tree");
				var nodes = treeObj.getCheckedNodes(true);
				var sNodeArr = [];
				for(var i=0;i<nodes.length;i++){
					sNodeArr.push(nodes[i].userId);
				}
				chartPaint(arr,sNodeArr);
				
				$('#table').bootstrapTable('load',arr);
        	}
        }
    };
    $.ajax(settings);
}
</script>
<script type="text/javascript">
var zNodes = ${userArr};
</script>
<script type="text/javascript">
Array.prototype.contains = function(item){
	for(var v in this){
		if(item==this[v]){
			return true;
		}
	}
    return false;
};

var zTree;
var demoIframe;

var setting = {
	check: {
		enable: true
	},
	view: {
		dblClickExpand: false,
		showLine: true,
		selectedMulti: false,
		fontCss: getFontCss
	},
	data: {
		key: {
			name: "userName",
			title: "ggg",
			icon: "icon"
		},
		simpleData: {
			enable:true,
			idKey: "userId",
			pIdKey: "pId",
			rootPId: ""
		}
	},
	callback: {
		beforeClick: function(treeId, treeNode) {
			var zTree = $.fn.zTree.getZTreeObj("tree");
			if (treeNode.isParent) {
				zTree.expandNode(treeNode);
				return false;
			} else {
				//demoIframe.attr("src",treeNode.file + ".html");
				return true;
			}
		},
		onCheck : function(event, treeId, treeNode){
			var treeObj = $.fn.zTree.getZTreeObj(treeId);
			var nodes = treeObj.getCheckedNodes(true);
			var sNodeArr = [];
			for(var i=0;i<nodes.length;i++){
				sNodeArr.push(nodes[i].userId);
			}
			chartPaint(arr,sNodeArr);
		}
	}
};

$(document).ready(function(){
	var t = $("#tree");
	t = $.fn.zTree.init(t, setting, zNodes);
});

function loadReady() {
	var bodyH = demoIframe.contents().find("body").get(0).scrollHeight,
	htmlH = demoIframe.contents().find("html").get(0).scrollHeight,
	maxH = Math.max(bodyH, htmlH), minH = Math.min(bodyH, htmlH),
	h = demoIframe.height() >= maxH ? minH:maxH ;
	if (h < 530) h = 530;
	demoIframe.height(h);
}
function getFontCss(treeId, treeNode) {  
    return (!!treeNode.highlight) ? {color:"#A60000", "font-weight":"bold"} : {color:"#333", "font-weight":"normal"};  
}

var nodeList = zNodes;
function treeFilter(id,key,value){  
  treeId = id;
  if(value!=""){
	  var treeObj = $.fn.zTree.getZTreeObj(treeId);
	  var nodes = treeObj.getNodesByParamFuzzy(key, value);
	  var ids = [];
	  for(var i=0;i<nodes.length;i++){
		  var node = nodes[i];
		  ids.push(node.userId);
		  while(node.level!=0){
			  node = treeObj.getNodeByTId(node.parentTId);
			  if(!ids.contains(node.userId)){
				  ids.push(node.userId);
			  }
		  }
	  }
	  for(var i=0;i<nodeList.length;i++){
		  var json = nodeList[i];
		  if(ids.contains(json.userId)){
			  //json.highlight = true;
			  json.isHidden = false;
		  }else{
			  //json.highlight = false;
			  json.isHidden = true;
		  }
	  }
	  updateNodes(nodeList);
  }else{
	  for(var i=0;i<nodeList.length;i++){
		  var json = nodeList[i];
		  //json.highlight = false;
		  json.isHidden = false;
	  }
	  updateNodes(nodeList);
  }
    
}  
function updateNodes(nodeList) {  
  var t = $("#tree");
  t = $.fn.zTree.init(t, setting, nodeList);
}

</script>
<script type="text/javascript">
	    function getTimeStr(param){
	    	var min = param%60;
	    	var hour = parseInt(param/60);
	    	var ret = "";
	    	if(hour!=0){
	    		ret += hour + "(h)";
	    	}
	    	if(min!=0){
	    		ret += min + "(min)";
	    	}
	    	if(ret==""){
	    		ret = "0";
	    	}
	    	return ret;
	    }
    	var arr = ${useronlineArr};
    	function chartPaint(dat,containArr){
    		var userNameArr = [];
        	var useronlineTimeArr = [];
        	var userForwardingTimerr = [];
        	var userDealTimerr = [];
        	var userForwardingNum = [];
        	var userDealNum = []
        	for(var i=0;i<dat.length;i++){
        		var json = dat[i];
        		if(containArr.length==0 || containArr.contains(json.userId)){
        			userNameArr.push(json.userAccount);
            		useronlineTimeArr.push(json.onlineTime);
            		userForwardingTimerr.push(json.forwardingDealAlarmTime)
            		userDealTimerr.push(json.dealAlarmTime);
            		userForwardingNum.push(json.forwardingAlarmTotalAmount);
            		userDealNum.push(json.dealAlarmTotalAmount);
        		}
        		
        	}
            // 基于准备好的dom，初始化echarts实例
            var timeChart = echarts.init(document.getElementById('time'));
            var numChart = echarts.init(document.getElementById('num'))

            // 指定图表的配置项和数据
            var timeOption = {
                title: {
                    text: ''
                },
                tooltip: {
                	trigger: 'axis',//axis  item
                    axisPointer : {            // 坐标轴指示器，坐标轴触发有效
                        type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                    },
                    formatter: function (params) {
                    	var ret = "";
                    	
                   		/* var tar = params;
                   		ret = tar.name + '<br/>' + tar.seriesName + ' : ' + tar.value + "(s)"; */
                    	
                   		for(var i=0;i<params.length;i++){
                       		var tar = params[i];
                       		if(ret==""){
                       			ret = tar.name + '<br/>' + tar.seriesName + ' : ' + getTimeStr(tar.value);
                       		}else{
                       			ret =  ret + '<br/>' + tar.seriesName + ' : ' + getTimeStr(tar.value);
                       		}
                       	}
                    	              	
                    	return ret;
                    }
                },
                legend: {
                    data:['<fmt:message key="performance.timeOption.legend.onlinetime"/>','<fmt:message key="performance.timeOption.legend.forwardtime"/>','<fmt:message key="performance.timeOption.legend.dealtime"/>']
                },
                yAxis: {
                    data: userNameArr
                },
                xAxis: {},
                series: [{
                    name: '<fmt:message key="performance.timeOption.legend.onlinetime" />',
                    type: 'bar',
                    data: useronlineTimeArr
                },{
                    name: '<fmt:message key="performance.timeOption.legend.forwardtime"/>',
                    type: 'bar',
                    data: userForwardingTimerr
                },{
                    name: '<fmt:message key="performance.timeOption.legend.dealtime"/>',
                    type: 'bar',
                    data: userDealTimerr
                }]
            };
            
            var numOption = {
                    title: {
                        text: ''
                    },
                    tooltip: {
                    	trigger: 'axis',//axis  item
                        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
                            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                        },
                        formatter: function (params) {
                        	var ret = "";
                        	
                       		/* var tar = params;
                       		ret = tar.name + '<br/>' + tar.seriesName + ' : ' + tar.value + "(s)"; */
                        	
                       		for(var i=0;i<params.length;i++){
                           		var tar = params[i];
                           		if(ret==""){
                           			ret = tar.name + '<br/>' + tar.seriesName + ' : ' + tar.value;
                           		}else{
                           			ret =  ret + '<br/>' + tar.seriesName + ' : ' + tar.value;
                           		}
                           	}
                        	              	
                        	return ret;
                        }
                    },
                    legend: {
                        data:['<fmt:message key="performance.numOption.legend.forwardnum" />','<fmt:message key="performance.numOption.legend.dealnum" />']
                    },
                    yAxis: {
                        data: userNameArr
                    },
                    xAxis: {},
                    series: [{
                        name: '<fmt:message key="performance.numOption.legend.forwardnum" />',
                        type: 'bar',
                        data: userForwardingNum
                    },{
                        name: '<fmt:message key="performance.numOption.legend.dealnum" />',
                        type: 'bar',
                        data: userDealNum
                    }]
                };

            // 使用刚指定的配置项和数据显示图表。
            timeChart.setOption(timeOption);
            
            numChart.setOption(numOption);
    	}
    	chartPaint(arr,[]);
</script>
<script type="text/javascript">
$(function() {
	$('#table').bootstrapTable({
		method:'post',
		//url:root+'/userMgmt/performanceAnalysis.action',
		//height: $(window).height() - 200,
		striped: true,
		dataType: "json",
		pagination: true, //分页
		idfield: "userId",
		sortName:"userId",
		"queryParamsType": "limit",
		singleSelect: false,
		contentType: "application/x-www-form-urlencoded",
		pageSize: 10,
		pageNumber:1,
		//totalRows:10,
		search: true, //不显示 搜索框
		showColumns: false, //不显示下拉框（选择显示的列）
		//sidePagination: "server", //服务端请求
		//queryParams: queryParams,
		//minimunCountColumns: 2,
		//responseHandler: responseHandler,
		pageList : [ 10, 20, 30 ],
		// search: true, //显示搜索框
		//sidePagination: "server", //服务端处理分页
		//pageSize: 3,
		//pageNumber:1,
	    columns: [
	     [{
	    	field:'userAccount',
	    	valign: 'middle',
	    	align:'center',
	    	rowspan:2,
	    	sortable:true,
	    	title:"<fmt:message key="performance.table.userAccount"/>"
	    },{
	    	field:'userName',
	    	rowspan:2,
	    	valign: 'middle',
	    	align:'center',
	    	sortable:true,
	    	title:"<fmt:message key="performance.table.userName"/>"
	    },{
	    	colspan:5,
	    	align:'center',
	    	title:"<fmt:message key="performance.table.userItems"/>"
	    }],
	    [{
	    	field:'onlineTime',
	    	align: 'center',
	    	sortable:true,
	    	title:"<fmt:message key="performance.table.onlineTime"/>"
	    },{
	    	field:'forwardingAlarmTotalAmount',
	    	align: 'center',
	    	sortable:true,
	    	title:"<fmt:message key="performance.table.forwardingAlarmTotalAmount"/>"
	    },{
	    	field:'forwardingDealAlarmTime',
	    	align: 'center',
	    	sortable:true,
	    	title:"<fmt:message key="performance.table.forwardingDealAlarmTime"/>"
	    },{
	    	field:'dealAlarmTotalAmount',
	    	align: 'center',
	    	title:"<fmt:message key="performance.table.dealAlarmTotalAmount"/>"
	    },{
	    	field:'dealAlarmTime',
	    	align: 'center',
	    	sortable:true,
	    	title:"<fmt:message key="performance.table.dealAlarmTime"/>"
	    }]
	     ],
	    data:arr
	});
});
//刷新tale
$(window).resize(function(){
	$('#table').bootstrapTable("resetView");
});
</script>
</body>
</html>