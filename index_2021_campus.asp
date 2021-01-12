<!-- #include virtual="/Public/Method.asp" -->
<!-- #include virtual="/Public/class.Mssql.asp" -->
<!-- #include virtual="/campus_common/lib/statistic_intro.asp" -->
<!-- #include virtual="/common/menubbs/menubbs.asp"-->

<%
	Dim strSql
	' 합격자 수
	' 2019-03-15 프로시저로 변경
	' year / type / 학원코드
	strSql = " SP_AMS_UNIV_APPLY_COUNT '2020','DOC','' "

	Dim tCnt : tCnt = 0
	Set objRs = objDb.sqlQueryNew(strSql, 1)
	If Not (objRs.EOF Or objRs.BOF) Then
		tCnt = objRs("TCNT")
		tRegDate = objRs("REG_DATE")
	End If
	objRs.Close
	Set objRs = Nothing

	'--경찰&사관 카운트. 2020-11-20 종료.
	'Dim intPolicePass : intPolicePass = 0
	'Dim intAirforcePass : intAirforcePass = 0
	'Dim intArmyPass : intArmyPass = 0
	'Dim intNavyPass : intNavyPass = 0
	'Dim intNursePass : intNursePass = 0
	'Dim intTotalPass : intTotalPass = 0

	'strSql = " SP_SPEC_UNIV_PASS_COUNT '2021', 0"
	'Set objRs = objDb.sqlQueryNew(strSql, 1)
	'If Not objRs.Eof Then
	'    intPolicePass = objRs("PCNT")
	'    intAirforcePass = objRs("ACNT")
	'    intArmyPass = objRs("YCNT")
	'    intNavyPass = objRs("HCNT")
	'    intNursePass = objRs("NCNT")
	'End If
	'objRs.Close
	'Set objRs = Nothing
	'intTotalPass = intPolicePass + intAirforcePass + intArmyPass + intNavyPass + intNursePass


	' 합격자 롤링 정보 데이터 검색.
	' YEAR, MAIN_YN, TOP_YN
	strSql = " EXEC MSP_MG_BOARD_SUGI '2020','', 'o'"

	Set objRs = objDb.sqlQueryNew(strSql,3)
	Dim arrList : arrList = Null
	Dim dCnt : dCnt = 0
	If Not (objRs.EoF And objRs.BoF) Then
		arrList = objRs.getrows
		dCnt = Ubound(arrList, 2)
	End If
	objRs.Close
	Set objRs = Nothing

	' 공지사항
	strSql = " EXEC MSP_MG_INDEX_NOTICE "' 2021-01-08 프로시저로 변경, 변경 : 이상준

	Set objRs = objDb.sqlQueryNew(strSql, 1)
	Dim arrIntroMegaByRS : arrIntroMegaByRS = null
	If Not (objRs.EOF Or objRs.BOF) Then
		arrIntroMegaByRS = objRs.GetRows()
	End If
	objRs.Close
	Set objRs = Nothing

	Dim arrMBList, dbIndex, dbTitle, dbUrl, dbUrlTarget, dbHCopy, dbSCopy, dbWidth, dbHegiht, dbBackColor, dbImage, dbSubImage, dI, dJ, dbIntroMainChk, autoPlayPopCheering
	dbIntroMainChk = "MAIN"
	autoPlayPopCheering = "FALSE"'영상 자동 재생 TRUE, FALSE
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
	<meta http-equiv="Content-Script-Type" content="text/javascript" />
	<meta http-equiv="Content-Style-Type" content="text/css" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
	<meta http-equiv="Pragma" content="no-cache" />
	<meta http-equiv="Cache-Control" content="no-cache" />
	<meta http-equiv="Expires" content="-1" />
	<meta name="viewport" content="" />
	<!-- #Include Virtual = "/library/include/reload/favicon.asp" -->
	<title><%=gMGC_Campus_Title%></title>
	<!-- #Include Virtual = "/library/include/reload/css_common.asp" --><!-- 사이트 공통 css -->
	<link rel="stylesheet" type="text/css" href="/library/css/intro_new_2019.css?v20171222001"><!-- intro전용 css -->
	<link rel="stylesheet" type="text/css" href="/library/css/intro_renew2018.css"><!-- intro전용 css -->
	<!-- #include virtual = "/public/jquery.asp" -->
	<script src="/public/js/waypoints.min.js"></script>
	<script src="/public/js/jquery.counterup.min.js"></script>

	<!-- #Include Virtual = "/library/include/reload/js_common.asp" -->
	<script type="text/javascript" src="/public/js/intro_renew2018.js"></script>
	<script src="/public/js/TweenMax.min.js"></script>
	<script type="text/javascript">
		$(document).ready(function(){
			$("#footer").addClass("intro_renew");

			// 메인배너 카운트 표시 2019-11-11
			var vBxLiCount = $(".top_bx > li").length -2;

			if (vBxLiCount > 0 ) {
				var vBxListStr = "";
				for (var i = 0;i <vBxLiCount; i++) {
					vBxListStr += "<a class='pager" + (i + 1) + "' data-slide-index='" + i + "' href='javascript:;'></a>";
				}
				$("#top_bx_pager").append(vBxListStr);

				$("#top_bx_pager > .pager1").addClass("active");
			}

			$("#bottom_bx_pager a").on("click", function(e){
				e. preventDefault();
				var idx = $(this).attr("data-slide-index");

				$("#bottom_bx_pager a").removeClass("active");
				if($(this).hasClass("ver1")) {
					$(this).stop().css({width: "115px"});
				}

				$(this).addClass("active");

				$(".bottom_bx > li .animation_element").removeClass("animation_set");
				$(".bottom_bx > li").stop().hide(0);


				$(".bottom_bx > li").eq(idx).stop().show(500);
				$(".bottom_bx > li").eq(idx).find(".animation_element").addClass("animation_set");
			});

			$('#bottom_bx_pager a').on('mouseover focusin', function(e){
				e. preventDefault();
				var idx = $(this).attr("data-slide-index");

				$('#bottom_bx_pager a.ver1').removeClass("none");
				if($(this).hasClass("active")) {
				}else {
					if($(this).hasClass("ver1")){
						$(this).stop().animate({width: "300px"});
						if($(this).hasClass("active")) {
							$('#bottom_bx_pager a.ver1').addClass("none");
							$(this).removeClass("none");
						}
					}
				}
			});

			$('#bottom_bx_pager a').on('mouseout focusout', function(e){
				e. preventDefault();
				var idx = $(this).attr("data-slide-index");

				$('#bottom_bx_pager a.ver1').removeClass("none");

				$('#bottom_bx_pager a.ver1').stop().animate({width: "115px"});

			});

			// rolling result wrap
			$('.counter').counterUp({
				delay: 10,
				time: 1100
			});

			// 합격청신호
			$(".inner_btn1").mouseover(function(){
				$(".inner_popup1").toggle(function(){
					$(".inner_popup1").animate({width:"200px", height:"200px"}, "fast");
				});
			});
			$(".inner_popup1").mouseout(function(){
				$(".inner_popup1").toggle(function(){
					$(".inner_popup1").animate({width:"0px", height:"0px"}, "fast");
				});
			});

			// 합격 맞춤형 시스템
			$(".triple_banner .img_wrap_hd img").on('mouseover focusin', function(){
				var image = $(this);
				var button = document.getElementById('start');

				var motion1 = new TimelineMax({delay:0,repeat:0})
				motion1.to(image, 0.3, {opacity:1, "transform":"scale(1.05)"})
			});
			$(".triple_banner .img_wrap_hd img").on('mouseout focusout', function(){
				var image = $(this);
				var button = document.getElementById('start');

				var motion1 = new TimelineMax({delay:0,repeat:0})
				motion1.to(image, 0.3, {opacity:1, "transform":"scale(1)"})
			});
		});

		function setCookie(name, value, expiredays){
			var todayDate = new Date();
			todayDate.setDate(todayDate.getDate() + expiredays);
			document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";";
		}
		function fnCheckClose(ck){
			setCookie(ck, "OK", 1);
			fnLayerPopupClose(ck);
		}

		function fnLayerPopupClose(id) {
			$('#' + id).hide();
			$('.float_dim').hide();
		}

        function setCookieAt00( name, value, expiredays ) {
			/*
				수정자 : 이상준
				수정 내용 : 날짜 처리 간편화, 오늘 날짜 + expiredays 시간은 00:00:00
				수정일 : 2021-01-08
			*/
            var todayDate = new Date();
			todayDate.setDate(todayDate.getDate() + expiredays);
			todayDate.setHours(0);
			todayDate.setMinutes(0);
			todayDate.setSeconds(0);
            document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";";
        }

        var fnPopPollMain = function(strSurveyNm, intHeight) {
            var wid = "500";
            var popupX = (document.body.offsetWidth / 2) - (wid / 2);
            var popUrl = "http://mcampus.megastudy.net/survey/" + strSurveyNm + "/";	//팝업창에 출력될 페이지 URL
            var popOption = "width=" + wid + ", height=" + intHeight + ", resizable=no, scrollbars=yes, status=no, left=" + popupX + ";";    //팝업창 옵션(optoin)
            window.open(popUrl, strSurveyNm, popOption);
        }

		// 메인 배너 리스트 click function 
		function fnBannerClick(idx, link, target, width, height) {
			$.ajax({
				type:"POST",
				url: "banner_click_check.asp",
				data: "idx=" + idx ,
				success: function() {
					if (link != "") {
						if (target == "P" && width > 0 && height > 0) {
							window.open(link,"mainBnr_ "+ idx ,"width=" + width + ",height=" + height + ", resizable=no, scrollbars=yes, status=no").focus();
						} else if (target == "B" ) {
							window.open(link);
						} else {
							location.href = link;
						}
					}
				},
				error: function(xhr, textStatus, errorThrown) {
					alert("에러가 발생했습니다.\n잠시후 다시 시도해주세요.");
				}
			});
		}

		//자동 영상 재생
		function autoPlayPopCheering(){
			$(".laypop_cheering").addClass("open");
			$("#player_cheering").attr("src","https://tv.naver.com/embed/16473159?autoPlay=true");
		};

		//클릭했을때 영상 재생
		function clickPlayPopCheering(){
			$(".laypop_cheering").addClass("open");
			$("#player_cheering").attr("src","https://tv.naver.com/embed/16473159?autoPlay=false");
		};
		
		//영상 팝업 닫기
		function closePop(){
			$(".laypop_cheering").removeClass("open");
			$("#player_cheering").attr("src","");
		};
	</script>
</head>
<body>
	<div id="lsj" style="background-color:red; padding:30px; text-align:center;"><h1>작성중... 이상준</h1></div><!-- 작업 완료 시 삭제 -->

	<!-- wrapper -->
	<div id="wrapper" class="intro_wrap renew">

        <!-- 경찰대 합격자 배너 200821/2020-11-20 종료.
        <script>
            $(document).ready(function (){
                // 변수를 선언
                var count = 5;
                var repeat = setInterval(function () {        // 타이머
                    count = count -1;
                    $("#pop200821 span em").html(count);
                    //alert(count);
                    if(count<=0){
                        $("#pop200821").fadeOut(1000);
                        clearInterval(repeat);

                    }
                }, 1000);

                $("#pop200821 .float_btn").click(function(){
                    $("#pop200821").fadeOut(1000);
                    clearInterval(repeat);
                });

				if ($("#divTopBanner").length > 0) {
					$("#pop200821.intro").css("margin-top", "273px");
				}
            });
        </script>
        <link rel="stylesheet" type="text/css" href="/library/css/result_css_p.css" />

        <div id="pop200821" class="intro">
            <div class="inner_pop_wrap">
                <a href="javascript:();" class="float_btn"></a>
                
                <a href="http://campus.megastudy.net/common/notice/notice_view.asp?code=17473" target="_self"  style="width:100%; height:677px; display:block; position:relative;">
                    <span class="popclose_btn"><em style="color:#aeaeaf;">5</em>초 뒤 닫힘</span>
                    <p class="number_sum"><span>총</span><strong><%=intTotalPass%></strong><span>명</span></p>
                    <ul class="result_list">
                        <li><p><strong><%=intPolicePass%></strong><span>명</span></p></li>                        
                        <li><p><strong><%=intArmyPass%></strong><span>명</span></p></li>
                        <li><p><strong><%=intNavyPass%></strong><span>명</span></p></li>
                        <li><p><strong><%=intAirforcePass%></strong><span>명</span></p></li>
                        <li><p><strong><%=intNursePass%></strong><span>명</span></p></li>
                    </ul>
                    <ul class="info_txt">                    
                        <li>* UPDATE: <%=Replace(FormatDateTime(Now(), 1), Right(FormatDateTime(Now(), 1), 4), "")& " " & Left(FormatDateTime(Now(), 4), 2)%>시 기준</li>
                        <li>* 해당 합격자는 메가스터디 전체 학원 재원생의 합격자 정보를 집계한 데이터 입니다.</li>
                        <li>* 합격자는 지속적으로 업데이트 중이며, 상세 합격 정보는 각 학원 사이트에서 확인 가능합니다.</li>
                        <li>* 단, 업데이트 시점에 따라 상세 합격 정보와 다를 수 있습니다.</li>
                    </ul>
                    <img src="https://img.megastudy.net/campus/library/v2015/library/intro_renew/popup_200902_intro.jpg" />
                </a>
            </div>
        </div>
         경찰대 합격자 배너 200821 -->

		<!-- float_right_banner -->
		<% '하단SS배너 
			arrMBList = fnMainBannerList(12, "INTRO", 5)
			If IsArray(arrMBList) Then
		%>
				<div class="float_right_banner">
					<div class="float_banner">
						<%
							For dI = 0 To Ubound(arrMBList, 2)
								dbIndex			= arrMBList(0, dI)
								dbTitle			= arrMBList(2, dI)
								dbImage			= arrMBList(4, dI)
								dbUrl			= arrMBList(9, dI)
								dbUrlTarget		= arrMBList(10, dI)
						%>
								<a href="javascript:fnBannerClick('<%=dbIndex%>','<%=dbUrl%>','<%=dbUrlTarget%>');" <% If dbUrlTarget = "N" Then %>style="cursor:default;"<% End If %>>
							<%
									If dbIndex = "22" Then '합격청신호 팝업 
							%>
										<img class="inner_popup1" src="<%=Application("img_path")%>/library/intro_renew/intro_ban_blue_big_1.jpg" alt="팝업" style="display:none;width:0;height:0;position:absolute;top:0;right:0px;z-index:9999;">
										<img class="inner_btn1" src="<%=dbImage%>" alt="<%=dbTitle%>" />
							<%
									Else
							%>
										<img src="<%=dbImage%>" alt="<%=dbTitle%>" />
							<%
									End If
							%> 
								</a>
						<%
							Next
						%>
					</div>
				</div>
		<%
			End If
		%>
		<!--// float_right_banner -->

		<div class="modal_dim"></div>
		<!-- 최상단메뉴 -->
		<!--#include virtual="/library/include/common/top.asp" -->
		<!--// 최상단메뉴-->

		<!-- header -->
		<div id="header_renew">
			<div class="top_nav_wrap">
				<%
					' 함수명 : ValueCheck
					' 기능설명 : Null 혹은 무입력값 검사
					If "2020-12-28 16:30:00" <= Now() And Now() < "2021-12-23 23:59:59" And ValueCheck(request.cookies("divPopup20201228")) = False Then
				%>
						<!-- 수능 수석합격자 팝업 201228 -->
						<div id="pop201228" class="intro">
							<div>
								<a href="/teamplay/info/2021_perfect.asp"><img src="<%=Application("img_path")%>/library/intro_renew/popup_210108_1.jpg" /></a>
								<!-- 팝업내용-->
								<div class="layerPop_bottom" style="width:100%;">
									<div class="check"><input type="checkbox" name="checkbox" value="checkbox" onclick="javascript:setCookieAt00('divPopup20201228', 'OK', 1);$('#pop201228').fadeOut(1000);"><span>오늘 하루 안보기 </span></div>
									<div class="float_btn" onclick="$('#pop201228').fadeOut(1000);"><span>닫기</span><em></em></div>
								</div>
							</div>
						</div>
						<!-- 수눙 수석합격자 팝업 201228 -->
				<%
					End If
				%>
                                                    
				<!-- 상단 대메뉴 -->
				<!-- #include virtual="/library/include/common/top_campus_intro_renew.asp" -->
				<!--// 상단 대메뉴-->
				<%
					'메인대배너 연동
					arrMBList = fnMainBannerList(2, "INTRO", null)
					If IsArray(arrMBList) Then
				%>
						<ul class="top_bx">
							<%
								For dI = 0 To Ubound(arrMBList, 2)
									dbIndex			= arrMBList(0, dI)
									dbTitle			= arrMBList(2, dI)
									dbImage			= arrMBList(4, dI)
									dbBackColor		= arrMBList(6, dI)
									dbUrl			= arrMBList(9, dI)
									dbUrlTarget		= arrMBList(10, dI)
							%>
									<!--<%=dbTitle%>-->
									<li style="background:<%=dbBackColor%> url('<%=dbImage%>') 50% 0% no-repeat;">
										<div class="tbx_img_wrap">
											<a href="javascript:fnBannerClick('<%=dbIndex%>','<%=dbUrl%>','<%=dbUrlTarget%>');" <% If dbUrlTarget = "N" Then %>style="cursor:default;"<% End If %> ></a>
										</div>
									</li>
									<!-- //<%=dbTitle%>-->
							<%
								Next
							%>
						</ul>
						<!-- pager -->
						<div style="width:1200px; position:relative; margin:0 auto;">
							<div id="top_bx_pager"></div>
						</div>
						<!-- //pager -->
				<%
					arrMBList = Null
					End If
				%>

				<%
					'고정배너 연동
					arrMBList = fnMainBannerList(11, "INTRO", 5)
					If IsArray(arrMBList) Then
				%>
						<div class="float_banner">
							<%
								For dI = 0 To Ubound(arrMBList, 2)
									dbIndex			= arrMBList(0, dI)
									dbTitle			= arrMBList(2, dI)
									dbImageYn		= arrMBList(3, dI)
									dbImage			= arrMBList(4, dI)
									dbBackColor		= arrMBList(6, dI)
									dbHCopy			= arrMBList(7, dI)
									dbSCopy			= arrMBList(8, dI)
									dbUrl			= arrMBList(9, dI) 
									dbUrlTarget		= arrMBList(10, dI)
									dbWidth			= arrMBList(11, dI)
									dbHeight		= arrMBList(12, dI)

									If dbImageYn = "Y" Then
							%>
										<a class="float" href="javascript:fnBannerClick('<%=dbIndex%>','<%=dbUrl%>','<%=dbUrlTarget%>','<%=dbWidth%>','<%=dbHeight%>');" <% If dbUrlTarget = "N" Then %>style="cursor:default;"<% End If %>>
											<img src="<%=dbImage%>" alt="<%=dbTitle%>" />
										</a>
								<%
									Else
								%>
									<a class="float txt_type <% If dbBackColor = "#ffffff" Then %>type01<% Else %>type02<% End If %>" style="background:<%=dbBackColor%>; <% If dbUrlTarget = "N" Then %>cursor:default;<% End If %>" 
									href="javascript:fnBannerClick('<%=dbIndex%>','<%=dbUrl%>','<%=dbUrlTarget%>','<%=dbWidth%>','<%=dbHeight%>');" >
										<p class="ad_top_txt"><%=dbSCopy%></p>
										<p class="ad_bottom_txt"><span><%=dbTitle%></span><%=dbHCopy%></p>
									</a>
							<%
									End If 
								Next
							%>
						</div>
				<%
					arrMBList = Null
					End If
				%>

				<%
					If "2020-10-12 00:00:00" <= Now() And Now() < "2020-12-12 00:00:00" And ValueCheck(request.cookies("laypop_cheering")) = False Then
				%>
						<!-- s인트로_수능 응원 영상 레이어 제작 및 타이머 세팅 영역 -->
						<style>
							.laypop_cheering{position:absolute;top:122px;left:0;right:0;bottom:0;z-index:10000;background:url("<%=Application("img_path")%>/library/intro_renew/intro_cheering/bg_cheering_2020.jpg") 50% no-repeat;background-size:cover;display:none;}
							.laypop_cheering.open{display:block;}
							.laypop_cheering .inner_player{position:absolute;top:50%;left:50%;margin:-320px 0 0 -486px;}
							.laypop_cheering .inner_player h1{margin-bottom: 7px;}
							.laypop_cheering .player_cheering{position:relative;overflow:hidden;width:960px;height:539px;padding-top:2px;border: 1px solid #dbdbdb;box-sizing:border-box;border-radius:7px;}
							.laypop_cheering .player_cheering::after{content:"";position:absolute;top:0;left:0;right:0;bottom:0;z-index:10;border:4px solid #ffffff;border-radius:5px;pointer-events:none;}
							.laypop_cheering .player_cheering iframe{overflow: hidden;}
							.laypop_cheering .inner_player .btn_close{position:absolute;top:-40px;right:-110px;width:70px;height:70px;background:url("<%=Application("img_path")%>/library/intro_renew/intro_cheering/btn_close02.png") left top no-repeat;color:transparent;font-size: 0;}
						</style>
						<div class="laypop_cheering">
							<!-- s영상영역 -->
							<div class="inner_player">
								<h1><img src="<%=Application("img_path")%>/library/intro_renew/intro_cheering/tit_cheering_2020.png" alt="메가스터디학원은 빛나는 당신의 꿈을 응원합니다!"></h1>
								<div class="player_cheering">
									<iframe id="player_cheering" width="960" height="535" src="https://tv.naver.com/embed/16473159" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
								</div>
								<a href="javascript:closePop();" class="btn_close">팝업 닫기</a>
							</div>
							<div class="layerPop_bottom" style="width:100%;">
								<div class="check"><input type="checkbox" name="checkbox" value="checkbox" onclick="javascript:setCookieAt00('laypop_cheering', 'OK', 1); closePop()">
									<span>오늘 하루 안보기</span>
								</div>
							</div>
							<!-- e영상영역 -->
						</div>

						<script>
							$(document).ready(function (){
								var playMode = "<%=autoPlayPopCheering%>";
								if(playMode === "TRUE"){
									autoPlayPopCheering();
								}
								else{
									clickPlayPopCheering();
								}
							});
						</script>
						<!-- e인트로_수능 응원 영상 레이어 제작 및 타이머 세팅 영역 -->
				<%
					End If
				%>
			</div>
		</div>
		<!--// header -->

		<%
			'의치한수 연동
			arrMBList = fnMainBannerList(3, "INTRO", 1)
			If IsArray(arrMBList) Then 
				dI = 0 
				dbIndex			= arrMBList(0, dI)
				dbTitle			= arrMBList(2, dI)
				dbImage			= arrMBList(4, dI)
				dbBackColor		= arrMBList(6, dI)
				dbUrl			= arrMBList(9, dI) 
				dbUrlTarget		= arrMBList(10, dI)
		%>
				<!--<%=dbTitle%>-->
				<div class="bnr_wrap" style="width:100%; background:<%=dbBackColor%> url('<%=dbImage%>') 50% top no-repeat; ">
					<div class="bnr" style="width:1200px; margin:0 auto; height:219px; position:relative;">
						<a href="javascript:fnBannerClick('<%=dbIndex%>','<%=dbUrl%>','<%=dbUrlTarget%>');" style="width:1200px;height:219px; display:block;<% If dbUrlTarget = "N" Then %>cursor:default;<% End If %>">
							<span class="txt"><em class="num"><%=tCnt%></em><em class="txt_m">명</em></span>
							<span class="info_date">UPDATE : <%=Year(date)%>년 <%=Month(date)%>월 <%=Day(date)%>일 <%=Hour(Now)%>시 기준</span>
						</a>
					</div>
				</div>
				<!--//<%=dbTitle%>-->
		<%
			arrMBList = Null
			End If 
		%>
		<!-- container -->

		<!-- rolling result wrap -->
		<div class="rolling_result_wrap">
			<div class="rolling_result">

				<div class="countup_wrap">
					<h3 class="sub_title">영광의 주인공 2020학년도 <span style="position:relative;"><img style="width:auto; height:auto; margin-top:13px;" src="<%=Application("img_path")%>/library/intro_renew/teamplay_star_bold_2.png"></span>팀플장학생</h3>
					<p class="sub_txt">대입 합격이라는 목표를 위해 내딛었던 발걸음<br>메가스터디학원을 만나 더욱 빛날 수 있었습니다.</p>

					<div class="scholarship_wrap renew">
						<a href="/campus_common/2020_team/">
							<h4 >
							<span>made by megastudy</span>제10회 <span style="position:relative;"><img style="width:auto; height:auto; margin-top:2px;" src="<%=Application("img_path")%>/library/intro_renew/teamplay_star_bold_1.png" /></span>팀플장학
							<span class="more_btn"><img style="width:auto; height:auto; margin-top:4px;" src="<%=Application("img_path")%>/library/intro_renew/scho_re_more_btn.gif" /></span>
							</h4>

							<div class="countup">
								<p class="number_wrap"><span class="title">누적 장학생</span><span class="counter" style="width:75px;">16,955</span><span class="normal">명</span></p>
								<p class="number_wrap"><span class="title">누적 장학금</span><span class="counter" style="width:42px;">460</span><span class="normal">억</span><span class="counter">2</span><span class="normal">천만원
								</span></p>
								<p class="txt">※ 메가스터디학원 입학/모의고사/졸업 장학금 전체 포함<br>&nbsp;&nbsp;&nbsp;(2011~2020학년도 누적)</p>
							</div>
						</a>

						<!-- 합격자 롤링 -->
						<ul class="scholarship_banner">
						<%
							If IsNull(arrList) = False Then
								For nLoopCnt = 0 To dCnt
									dbSeq = arrList(0, nLoopCnt)
									dbS_CodeName = arrList(2, nLoopCnt)
									dbS_Name = arrList(3, nLoopCnt)
									dbS_Type = arrList(8, nLoopCnt)
									dbS_Univ = arrList(4, nLoopCnt)
									dbS_Major = arrList(5, nLoopCnt)
									dbS_SUBJECT = arrList(6, nLoopCnt)

									If Instr(dbS_CodeName, " ") > 0 Then
										strArray = Split(dbS_CodeName, " ")
										strAcaName = "<span class=""location"">"& strArray(0) &"</span><br />"& strArray(1)
									Else
										strAcaName = "<span class=""location"">"& dbS_CodeName &"</span>"
									End If
						%>
									<a href="/campus_common/2020_team/?#liNm<%=dbSeq%>">
										<li>
											<div>
												<p class="campus"><%=strAcaName%></p>
												<p class="name"><%=dbS_Name%></p>
												<p class="circle"><%=dbS_Type%><br>합격</p>
												<p class="school"><strong><%=dbS_Univ%></strong><br><%=dbS_Major%></p>
												<p class="thanks_to"><span><%=UCase(strlen2(dbS_SUBJECT, 140))%></span></p>
											</div>
										</li>
									</a>
						<%
								Next
								arrList = Null
							End If
						%>
						</ul>
						<!-- //합격자 롤링 -->
					</div>
				</div>

				<div class="bottom_box">
					<%
						'팀플장학 하단 
						For dJ = 4 To 5 
							arrMBList = fnMainBannerList(dJ, "INTRO", 1)
							If IsArray(arrMBList) Then 
								dI = 0 
								dbIndex			= arrMBList(0, dI)
								dbTitle			= arrMBList(2, dI)
								dbImage			= arrMBList(4, dI)
								dbUrl			= arrMBList(9, dI) 
								dbUrlTarget		= arrMBList(10, dI)
					%>
							
								<div class="box">
									<a href="javascript:fnBannerClick('<%=dbIndex%>','<%=dbUrl%>','<%=dbUrlTarget%>');" <% If dbUrlTarget = "N" Then %>style="cursor:default;"<% End If %>>
										<img src="<%=dbImage%>" alt="<%=dbTitle%>" />
									</a>
								</div>
					<%		
							End If 
						Next 
					%> 
				</div>
			</div>
		</div>
		<!-- //rolling result wrap -->

		<!-- middle slick banner -->
		<%
			'설명회 
			arrMBList = fnMainBannerList(6, "INTRO", null)
			If IsArray(arrMBList) Then %>
				<div class="slick_banner_wrap">
					<div class="slick_banner">
						<div class="middle">
							<ul class="middle_slick">
								<%
									For dI = 0 To Ubound(arrMBList, 2)
										dbIndex			= arrMBList(0, dI)
										dbTitle			= arrMBList(2, dI)
										dbImage			= arrMBList(4, dI)
										dbUrl			= arrMBList(9, dI) 
										dbUrlTarget		= arrMBList(10, dI) 
								%>			
										<li>
											<a href="javascript:fnBannerClick('<%=dbIndex%>','<%=dbUrl%>','<%=dbUrlTarget%>');" <% If dbUrlTarget = "N" Then %>style="cursor:default;"<% End If %>>
												<img src="<%=dbImage%>" alt="<%=dbTitle%>" />
											</a>
										</li>
								<% 
									Next
								%>
							</ul>
						</div>
					</div>
				</div>
		<%
			arrMBList = Null
			End If
		%>
		<!--//middle slick banner -->

		<!-- triple banner -->
		<div class="triple_banner_wrap">
			<h3 class="sub_title">믿고 따르는 합격 맞춤형 시스템</h3>
			<p class="sub_txt">메가스터디학원의 목표는 오직 한가지, 합격입니다.<br>그렇기에 끊임없는 연구로 입시에 꼭 맞는 시스템을 완성했습니다.</p>
			<div class="triple_banner">
				<%
					'합격 맞춤형 시스템
					For dJ = 7 To 9
						arrMBList = fnMainBannerList(dJ, "INTRO", 5)
						If IsArray(arrMBList) Then
				%>
							<div class="t_banner banner0<%=dJ-6%>" style="position:relative;">
								<ul class="triple0<%=dJ-6%>">
									<%
										For dI = 0 To Ubound(arrMBList, 2) 
											dbIndex			= arrMBList(0, dI)
											dbImage			= arrMBList(4, dI)
											dbHCopy			= Replace(arrMBList(7, dI), Chr(13)&Chr(10), "<Br />")
											dbSCopy			= Replace(arrMBList(8, dI), Chr(13)&Chr(10), "<Br />")
											dbUrl			= arrMBList(9, dI) 
											dbUrlTarget		= arrMBList(10, dI)
									%>
											<li>
												<a href="javascript:fnBannerClick('<%=dbIndex%>','<%=dbUrl%>','<%=dbUrlTarget%>');" <% If dbUrlTarget = "N" Then %>style="cursor:default;"<% End If %>>
													<div class="img_wrap_hd"><img src="<%=dbImage%>" /></div>
													<h4 class="t_b_title" style="position:relative;"><%=dbHCopy%></h4>
													<p class="t_b_txt"><%=dbSCopy%></p>
												</a>
											</li>
									<%
										Next
									%>
								</ul>
							</div>
				<%
						arrMBList = Null
						End If 
					Next
				%>
			</div>
		</div>
		<!-- //triple banner -->

        <%
			'하단와이드
			arrMBList = fnMainBannerList(dJ, "INTRO", 10) 
			If IsArray(arrMBList) Then 
				dI = 0 
				dbIndex			= arrMBList(0, dI)
				dbTitle			= arrMBList(2, dI)
				dbImage			= arrMBList(4, dI)
				dbUrl			= arrMBList(9, dI) 
				dbUrlTarget		= arrMBList(10, dI)
		%>
				<div class="plus_banner_wrap">
					<div class="plus_banner">
						<a href="javascript:fnBannerClick('<%=dbIndex%>','<%=dbUrl%>','<%=dbUrlTarget%>');" <% If dbUrlTarget = "N" Then %>style="cursor:default;"<% End If %>>
							<img src="<%=dbImage%>" alt="<%=dbTitle%>" />
						</a>
					</div>
				</div>
		<%
			End If
		%>

		<div class="main_bottom_wrap">
			<h3 class="sub_title">입시 성공의 KEY, 메가스터디학원</h3>
			<p class="sub_txt">이미 수많은 합격자 수로 증명된 입시 명문<br>메가스터디학원만이 가능한 학습 시스템을 경험하세요.</p>
			<div class="main_bottom">
				<!--  학원별 메뉴 -->
				<!-- #include virtual="/library/include/common/center_campus_intro_renew.asp" -->
				<!--// 학원별 메뉴 -->
			</div>
		</div>

		<!-- notice wrap -->
		<%
			If Not IsNull(arrIntroMegaByRS) Then
		%>
				<div class="notice_wrap renew">
					<div class="notice">
						<h4>공지사항</h4>
						<div class="bottom_notice_wrap">
							<ul class="bottom_notice">
								<%
									If isarray(arrIntroMegaByRS) Then
										For iib = 0 To ubound(arrIntroMegaByRS, 2)
											IntroMegaBy_CODE		= arrIntroMegaByRS(0, iib)
											IntroMegaBy_SUBJECT	= arrIntroMegaByRS(1, iib)
											IntroMegaBy_RegDate		= arrIntroMegaByRS(3, iib)
											IntroMegaBy_DtDff		= arrIntroMegaByRS(6, iib)
								%>
											<li>
												<a href="/common/notice/notice_view.asp?code=<%=IntroMegaBy_CODE%>"><p><span><%=IntroMegaBy_SUBJECT%>
												<%If IntroMegaBy_DtDff <= 7 Then%><em class="ir_ico new"></em><%End If%></span></p></a>
											</li>
								<%
										Next
									End If
								%>
							</ul>
						</div>
						<a class="all_view" href="/common/notice/notice.asp"><span>+</span> 전체보기</a>
					</div>
				</div>
		<%
			End if
		%>
		<!-- //notice wrap -->
		<!-- // container -->

		<!--  최하단메뉴//-->
		<!--#include virtual="/library/include/common/bottom.asp" -->
		<!--  //최하단메뉴-->

	</div>
	<!-- // wrapper -->
</body>
</html>
<%
	statistic("INTRO")
%>