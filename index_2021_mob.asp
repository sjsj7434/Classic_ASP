<!--#include virtual="/common/common_inc.asp" -->
<%
	'=======================
	' 작업일자 : 2020-07-21 CSB
	' 작업내용 : 메인 - SVN
	'=======================
	Dim strSql
	' 합격자 수
	' 2019-03-15 프로시저로 변경
	' year / type / 학원코드
	strSql = "EXEC SP_AMS_UNIV_APPLY_COUNT '2020','DOC','' "

	Dim tCnt : tCnt = 0
	Set objRs = objDb.sqlQueryNew(strSql, 1)
	If Not (objRs.EOF Or objRs.BOF) Then
		tCnt = objRs("TCNT")
		tRegDate = objRs("REG_DATE")
	End If
	objRs.Close
	Set objRs = Nothing

	' 팀플장학생 - 합격자 롤링 정보 데이터 검색.
	' YEAR, MAIN_YN, TOP_YN
	strSql = " EXEC MSP_MG_BOARD_SUGI '2020','', 'o'"

	Set objRs = objDb.sqlQueryNew(strSql,3)
	Dim arrList : arrList = Null
	Dim dCnt : dCnt = 0
	If Not (objRs.EoF And objRs.BoF) Then
		arrList = objRs.getrows
		dCnt = Ubound(arrList, 2)
	End If
	objRs.close
	Set objRs = Nothing

	' 공지사항
	strSql = " EXEC SP_CAMPUS_MAIN_ACA_NOTICE_LIST 'INTRO','' "

	Set objRs = objDb.sqlQueryNew(strSql, 1)
	Dim arrIntroMegaByRS : arrIntroMegaByRS = null
	If Not (objRs.EOF Or objRs.BOF) Then
		arrIntroMegaByRS = objRs.GetRows()
	End If
	objRs.Close
	Set objRs = Nothing

	Dim arrMBList, dbIndex, dbTitle, dbUrl, dbUrlTarget, dbHCopy, dbSCopy, dbBackColor, dbImage, dI, dJ
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
	<!-- header 시작 -->
	<!-- #include virtual="/include/header.asp" -->
	<!-- //header -->
	<script type="text/javascript" src="/asset/js/intro.js"></script>
	<script type="text/javascript" src="/asset/js/pre_reser.js"></script>

	<script type="text/javascript">
		var popchk = false;
		$(window).on("hashchange", function(){
			if (popchk == true) {
				location.href = "/index.asp"
			}
		})

		// 학원 정보 가지고오기
		function PopAcaInfo(ccode_detail) {
			if(ccode_detail != '') {
				$.ajax({
					url : "/include/ajax_main_aca_info.asp",
					type : "POST",
					dataType : "html",
					data : {ccode_detail : ccode_detail},
					success : function(result) {
						$("#AcaInfoView").html(result);
						// 레이어열기
						pop_up_open();
					},
					error : function(result) {

					}
				});
			}
		}

		// 메인 배너 리스트 click function
		function fnBannerClick(idx, link, target) {
			$.ajax({
				type:"POST",
				url: "banner_click_check.asp",
				data: "idx=" + idx ,
				success: function() {
					// 아이폰에서 팝업으로 인식하는 문제로 a 링크에 바로 _blank 설정하도록 로직 변경(2020.11.23)
					if (link != "") {
						if (target == "B" ) {
							//window.open(link);
						} else {
							//location.href = link;
						}
					}
				},
				error: function(xhr, textStatus, errorThrown) {
					//alert("에러가 발생했습니다.\n잠시후 다시 시도해주세요.");
				}
			});
		}
	</script>

	<!-- S : 인트로_수능 응원 영상 레이어 제작 및 타이머 세팅 영역 20201102 -->
	<style>
		.laypop_201228{position:fixed;top:50%;left:0;right:0;z-index:150;display:none;}
		.laypop_201228 .cheering_inner {height:100%; /*padding-bottom:5%; overflow-y:scroll;*/}
		.laypop_201228.open{display:block;}
		.laypop_201228 h1{margin:0;font-size:0;}
		.laypop_201228 h1 img{width:100%;}
		.laypop_201228 .inner_player{padding:0 5%;}
		.laypop_201228 .inner_player .box_player{position:relative;overflow:hidden;width:100%;/*padding-bottom:55.7%;*/box-sizing:border-box;}
		.laypop_201228 .player_cheering{position:absolute;top:1px;left:0;width:calc(100% - 2px);height:calc(100% - 2px);border-radius:4px;}
		.laypop_201228 .player_cheering iframe{border-radius:4px;}
		.laypop_201228 .inner_player .popclose_btn{position:absolute;top:3%;right:8%; width:20px; height:20px;/* width:70px;height:70px; */background:url("<%=Application("img_path_mob")%>/asset/img/close_x.png") 50% 50% no-repeat;background-size:100% 100%; font-size:12px; color:#fff; line-height:1.2;}
		.laypop_201228 .inner_player .popclose_btn span {display:inline-block; width:50px; text-align:center; position:absolute; top:125%; left:50%;  margin-left:-25px;}
		.laypop_201228 .inner_player .popclose_btn em {font-style:normal; color:#fff;}
		.no-scroll{overflow:hidden;position: fixed}
	</style>
	<script>
		$( function(){
			//$('body').addClass('of_hid');

			/*
			$( '#btn_cheering' ).click( function(){
				playPopCheering();
			} );
			*/
		} );

		var count = 5;

		function laypop_201228Pop() {
			playPopHCalc();

			$(".laypop_201228").show();
			$('.pop_dim').show().css("z-index",8);
			//$('body').addClass('of_hid');
			$('body').addClass('no-scroll');

			/*var repeat = setInterval(function () {
				// 타이머
				count = count -1;
				$(".popclose_btn em").html(count);
				//alert(count);
				if(count<=0){
					$(".laypop_201228").fadeOut(1000);
					$( '.pop_dim' ).hide();
					$('body').removeClass('no-scroll');
					//$('body').removeClass('of_hid');
					$('.pop_dim').css("z-index",7);
					clearInterval(repeat);
				}
			}, 1000);
			*/
		}

		function playPopCheering() {
			$("#laypop_cheering").addClass('open');
			$("#player_cheering").attr("src","https://tv.naver.com/embed/16473159?autoPlay=true");
		}

		function playPopHCalc() {
			var pop_h = $(".laypop_201228").outerHeight();
			if($(window).height() < pop_h) {
				$(".laypop_201228").css("margin-top", 0);
				$(".laypop_201228").css("top", 0);
				//$(".cheering_inner").css("height", pop_h);
			}
			else {
				$(".laypop_201228").css("margin-top", -pop_h/2);
			}
		}

		function closePop(){
			$(".laypop_201228").hide();
			//$("#player_cheering").attr("src","");
			$( '.pop_dim' ).hide();
			$('body').removeClass('no-scroll');
			//$('body').removeClass('of_hid');
			$('.pop_dim').css("z-index",7);
			//clearInterval(repeat);
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

		$(window).on({
			"load":function(){

			},
			"resize":function(){
				playPopHCalc();
			},
			"scroll":function(){

			}
		});
	</script>
	<!-- E : 인트로_수능 응원 영상 레이어 제작 및 타이머 세팅 영역 20201102 -->
</head>

<body>
	<div id="lsj" style="background-color:red; padding:30px; text-align:center;"><h1>작성중... 이상준</h1></div><!-- 작업 완료 시 삭제 -->

	<% 'TOP 배너 연동
		arrMBList = fnMainBannerList(1, "INTRO", null)

		If IsArray(arrMBList) Then
			For dI = 0 To Ubound(arrMBList, 2)
				dbIndex			= arrMBList(0, dI)
				dbTitle			= arrMBList(2, dI)
				dbImage			= arrMBList(4, dI)
				dbUrl			= arrMBList(9, dI)
				dbUrlTarget		= arrMBList(10, dI)
	%>
				<div class="top_fix_bnr active">
					<!--<span class="top_f_b_close"></span>-->
					<a href="<%=dbUrl%>" onclick="fnBannerClick('<%=dbIndex%>','<%=dbUrl%>','<%=dbUrlTarget%>');" <%=IIF(dbUrlTarget = "B", "target='_blank' ", "")%>>
						<img src="<%=dbImage%>" alt="">
					</a>
				</div>
	<%
			Next
		End If
	%>

	<section class="wrap main">
		<!-- 경찰대 합격자 배너 2020-11-20 종료.-->
		<!-- include virtual="/include/inc_main_banner.asp" -->
		<!-- //경찰대 합격자 배너 -->

		<%
			' 수능 응원 영상 레이어 - 12/2 10시부터는 인트로 집입시 뜨도록 셋팅 (경찰배너가 내려가야 하므로.. 11월말에 경찰배너 체크!!)
			If "2020-12-02 10:00:00" <= Now() And Now() < "2020-12-03 18:00:00" Then
		%>
				<!-- S : 인트로_수능 응원 영상 레이어 제작 및 타이머 세팅 영역 20201102 -->
				<div class="laypop_cheering">
					<div class="cheering_inner">
						<h1><img src="<%=Application("img_path_mob")%>/asset/img/m_tit_cheering_2020.png" alt="메가스터디학원은 빛나는 당신의 꿈을 응원합니다!"></h1>
						<div class="inner_player">
							<div class="box_player">
								<iframe id="player_cheering" class="player_cheering" src="" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
							</div>
							<a class="btn_close" id="btn_closeCheering">팝업 닫기</a>
						</div>
					</div>
				</div>
				<script type="text/javascript">
					$(document).ready(function (){
						playPopCheering();
					});
				</script>
		<%
			End If
		%>

		<%
			' 수능 응원 영상 레이어 - 12/2 10시부터는 인트로 집입시 뜨도록 셋팅 (경찰배너가 내려가야 하므로.. 11월말에 경찰배너 체크!!)
			If "2020-12-02 10:00:00" <= Now() And Now() < "2022-12-03 18:00:00" And request.cookies("laypop_201228")  <> "OK" Then
		%>
				<div class="laypop_201228">
					<div class="cheering_inner">
						<div class="inner_player">
							<div class="box_player">
								<img src="<%=Application("img_path_mob")%>/asset/img/popup_201228_m.jpg" alt="">
							</div>
							<div class="popclose_btn" onClick="closePop()">
								<!--<span><em>5</em>초 후<br>닫힘</span>-->
							</div>
							<div style="background-color:red; height:'40px';" onClick="setCookieAt00('laypop_201228', 'OK', 1); closePop();">
								<p>.</p>
								<h2>오늘 하루 안보기</h2>
								<p>.</p>
							</div>
						</div>
					</div>
				</div>
				<script type="text/javascript">
					$(document).ready(function (){
						laypop_201228Pop();
					});
				</script>
		<%
			End If
		%>
		
		<!-- //E : 인트로_수능 응원 영상 레이어 제작 및 타이머 세팅 영역 20201102 -->

		<!-- 상위메뉴 -->
		<!-- #include virtual="/include/top.asp" -->
		<!-- //상위메뉴 -->

		<!-- 메인슬라이드 전체보기 -->
		<div class="all_visu_ban_pop_wrap">
			<div class="m_inner">
				<div class="all_visu_title">
					<p>전체보기</p>
					<div class="close_btn">
						<span></span>
						<span></span>
					</div>
				</div>
				<ul class="all_visu_ban_area">
					<% '메인슬라이드 연동 (전체보기)
						arrMBList = fnMainBannerList(2, "INTRO", null)

						If IsArray(arrMBList) Then
							For dI = 0 To Ubound(arrMBList, 2)
								dbIndex			= arrMBList(0, dI)
								dbTitle			= arrMBList(2, dI)
								dbImage			= arrMBList(4, dI)
								dbUrl			= arrMBList(9, dI)
								dbUrlTarget		= arrMBList(10, dI)
					%>
								<li><a href="<%=dbUrl%>" onclick="fnBannerClick('<%=dbIndex%>','<%=dbUrl%>','<%=dbUrlTarget%>');" <%=IIF(dbUrlTarget = "B", "target='_blank' ", "")%>><img src="<%=dbImage%>" alt="" /></a></li>
					<%
							Next
						End If
					%>
				</ul>
			</div>
		</div>
		<!-- //메인슬라이드 전체보기 -->

		<section class="contents_wrap">
			<!-- 메인슬라이드 -->
			<div class="main_visual_wrap">
				<div class="slider main_visu">
					<% '메인슬라이드 연동
						If IsArray(arrMBList) Then
							For dI = 0 To Ubound(arrMBList, 2)
								dbIndex			= arrMBList(0, dI)
								dbTitle			= arrMBList(2, dI)
								dbImage			= arrMBList(4, dI)
								dbUrl			= arrMBList(9, dI)
								dbUrlTarget		= arrMBList(10, dI)
					%>
								<div>
									<div class="img_wrap"><a href="<%=dbUrl%>" onclick="fnBannerClick('<%=dbIndex%>','<%=dbUrl%>','<%=dbUrlTarget%>');" <%=IIF(dbUrlTarget = "B", "target='_blank' ", "")%>><img src="<%=dbImage%>" alt="" /></a></div>
								</div>
					<%
							Next
							arrMBList = Null
						End If
					%>
				</div>
				<div class="pagingInfo"><span></span><em></em></div>
			</div>
			<!-- //메인슬라이드 -->

			<!-- 의치한수 합격현황 -->
			<div class="impor_bnr_wrap">
				<a href="/common/notice/notice_view.asp?code=16072">
					<div class="impor_bnr_area m_inner">
						<div class="box">
							<p class="title">2020학년도 메가스터디학원</p>
							<p class="name"><strong><span class="color_ffd109">의치한수</span> 합격현황</strong></p>
						</div>
						<div class="box">
							<strong class="impor_num numb color_ffd109"><%=tCnt%></strong><em>명</em>
						</div>
					</div>
					<p class="info">※ <%=Year(date)%>.<%=Month(date)%>.<%=Day(date)%>&nbsp;<%=Hour(Now)%>시 기준</p>
				</a>
			</div>
			<!-- //의치한수 합격현황 -->

			<div>
				<!-- 상단 SS 슬라이드 -->
				<div class="ss_bnr_cover">
					<div class="ss_bnr_wrap">
						<div class="slider ss_bnr">
							<% '상단 SS 슬라이드 연동
								arrMBList = fnMainBannerList(3, "INTRO", null)

								If IsArray(arrMBList) Then
									For dI = 0 To Ubound(arrMBList, 2)
										dbIndex			= arrMBList(0, dI)
										dbTitle			= arrMBList(2, dI)
										dbImage			= arrMBList(4, dI)
										dbBackColor		= arrMBList(6, dI)
										dbHCopy			= Replace(arrMBList(7, dI), Chr(13)&Chr(10), "<Br />")
										dbSCopy			= Replace(arrMBList(8, dI), Chr(13)&Chr(10), "<Br />")
										dbUrl			= arrMBList(9, dI)
										dbUrlTarget		= arrMBList(10, dI)
							%>
										<div class="ss_bnr_area" id="divSsSlide<%=dbIndex%>">
											<a class="ss_area" href="<%=dbUrl%>" onclick="fnBannerClick('<%=dbIndex%>','<%=dbUrl%>','<%=dbUrlTarget%>');" <%=IIF(dbUrlTarget = "B", "target='_blank' ", "")%> style="background:<%=dbBackColor%> !important;">
												<p>
													<span><%=dbSCopy%></span>
													<span><strong><%=dbHCopy%></strong></span>
												</p>
											</a>
										</div>
							<%
									Next
									arrMBList = Null
								End If
							%>
						</div>
					</div>
				</div>
				<!-- //상단 SS 슬라이드 -->

				<!-- 상단 SS 리스트 -->
				<ul class="system_list_bnr m_inner">
					<% '상단 SS 리스트 연동
						arrMBList = fnMainBannerList(4, "INTRO", 5)

						If IsArray(arrMBList) Then
							For dI = 0 To Ubound(arrMBList, 2)
								dbIndex			= arrMBList(0, dI)
								dbTitle			= arrMBList(2, dI)
								dbUrl			= arrMBList(9, dI)
								dbUrlTarget		= arrMBList(10, dI)
					%>
								<li>
									<a href="<%=dbUrl%>" onclick="fnBannerClick('<%=dbIndex%>','<%=dbUrl%>','<%=dbUrlTarget%>');" <%=IIF(dbUrlTarget = "B", "target='_blank' ", "")%>><%=dbTitle%></a>
								</li>
					<%
							Next
							arrMBList = Null
						End If
					%>
				</ul>
				<!-- //상단 SS 리스트  -->
			</div>

			<!-- 팀플장학 -->
			<div class="teample_wrap of_hid">
				<h3 class="m_sub_title">made by megastudy<strong><em class="star"><img src="<%=Application("img_path_mob")%>/asset/img/teample_star01.png" alt="" /></em>팀플장학</strong></h3>
				<div class="teample_box">
					<p class="box_title"><em class="star"><img src="<%=Application("img_path_mob")%>/asset/img/teample_star02.png" alt="" /></em>팀플장학금 지급현황</p>
					<ul class="counter_wrap m_inner">
						<li><p><span class="left">누적 장학생</span><span class="middle"><strong class="num01">16,955</strong></span><span class="right">명</span></p></li>
						<li><p><span class="left">누적 장학금</span><span class="middle"><strong class="num02">460</strong>억 <strong class="num03">2</strong>천만</span><span class="right">원</span></p></li>
					</ul>
				</div>
				<p class="teample_sub_txt">※메가스터디학원 입학/모의고사/졸업 장학금 전체 포함<br>(2011~2020학년도 누적)</p>


				<h4 class="flow_title">제10회<span><em class="star"><img src="<%=Application("img_path_mob")%>/asset/img/teample_star03.png" alt="" /></em>팀플장학생</span></h4>
				<!-- 합격자 롤링 -->
				<div class="slide_area">
					<a href="#">
						<ul class="slide_wrap cl">
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
											strAcaName = "<span class=""location"">"& strArray(0) &"</span> "& strArray(1)
										Else
											strAcaName = "<span class=""location"">"& dbS_CodeName &"</span>"
										End If
							%>
											<a href="/campus_common/2020_team/?#liNm<%=dbSeq%>">
												<li>
													<img src="<%=Application("img_path_mob")%>/asset/img/flow_icon01.png" alt="" />
													<p><%=strAcaName%><strong><%=dbS_Name%></strong> <span><em><%=dbS_Univ%></em> <%=dbS_Major%></span></p>
												</li>
											</a>
							<%
									Next
									arrList = Null
								End If
							%>
						</ul>
					</a>
				</div>
				<!-- //합격자 롤링 -->

				<div class="m_btn_wrap">
					<a class="arrow_btn" href="/teamplay/interview/2020/index.asp">재수성공 스토리</a>
					<a class="arrow_btn" href="/teamplay/enter/template/list.asp?year=2020">선배들의 성공노하우</a>
				</div>

				<!-- 팀플장학생 신청하기 버튼 -->
				<!--<div class="m_btn_wrap m_inner">
					<a href="#none" class="m_btn_area type01">제11회<span><em class="star"><img src="<%=Application("img_path_mob")%>/asset/img/teample_star04.png" alt="" /></em>팀플장학 신청하기</span></a>
				</div>-->
			</div>
			<!-- // 팀플장학생 -->

			<!-- 합격 맞춤형 시스템 -->
			<div class="system_wrap of_hid">
				<h3 class="m_sub_title">믿고 따르는<strong>합격 맞춤형 시스템</strong></h3>
				<div style="background:#fff">
					<div class="slider center">
					<% '합격 맞춤형 시스템 연동
						arrMBList = fnMainBannerList(5, "INTRO", 15)

						If IsArray(arrMBList) Then
							For dI = 0 To Ubound(arrMBList, 2)
								dbIndex			= arrMBList(0, dI)
								dbTitle			= arrMBList(2, dI)
								dbImage			= arrMBList(4, dI)
								dbBackColor		= arrMBList(6, dI)
								dbHCopy			= Replace(arrMBList(7, dI), Chr(13)&Chr(10), "<Br />")
								dbSCopy			= Replace(arrMBList(8, dI), Chr(13)&Chr(10), "<Br />")
								dbUrl			= arrMBList(9, dI)
								dbUrlTarget		= arrMBList(10, dI)
					%>
								<div>
									<div class="img_wrap"><a href="<%=dbUrl%>" onclick="fnBannerClick('<%=dbIndex%>','<%=dbUrl%>','<%=dbUrlTarget%>');" <%=IIF(dbUrlTarget = "B", "target='_blank' ", "")%>><img src="<%=dbImage%>" alt="" /></a></div>
								</div>
					<%
							Next
							arrMBList = Null
						End If
					%>
					</div>
				</div>

				<div class="bg_line mt50"></div>

				<ul class="system_list_bnr m_inner">
					<% '하단 SS 리스트 연동
						arrMBList = fnMainBannerList(6, "INTRO", 4)

						If IsArray(arrMBList) Then
							For dI = 0 To Ubound(arrMBList, 2)
								dbIndex			= arrMBList(0, dI)
								dbTitle			= arrMBList(2, dI)
								dbUrl			= arrMBList(9, dI)
								dbUrlTarget		= arrMBList(10, dI)
					%>
								<li>
									<a href="<%=dbUrl%>" onclick="fnBannerClick('<%=dbIndex%>','<%=dbUrl%>','<%=dbUrlTarget%>');" <%=IIF(dbUrlTarget = "B", "target='_blank' ", "")%>><%=dbTitle%></a>
								</li>
					<%
							Next
							arrMBList = Null
						End If
					%>
				</ul>
			</div>
			<!-- //합격 맞춤형 시스템 -->

			<!-- 학원 바로가기 -->
			<div id="bottom_bx_pager">
				<div class="m_inner">
					<h3 class="m_sub_title">입시 성공의 KEY<strong>메가스터디학원</strong></h3>

					<h4><strong>재수 기숙학원</strong></h4>
					<a class="pager pager01 ver1" href="javascript:PopAcaInfo('CD0220');"><strong>양지 기숙<em>국내 최대 상위권전문</em></strong></a>
					<a class="pager pager02 ver1" href="javascript:PopAcaInfo('CD0243');"><strong>서초 기숙<em>자연계 상위권전문</em></strong></a>

					<h4><strong>재수 통학학원</strong></h4>
					<a class="pager pager03 ver3" href="javascript:PopAcaInfo('CD0206');"><strong>강남 팀플전문관</strong></a>
					<a class="pager pager04 ver3" href="javascript:PopAcaInfo('CD0208');"><strong>서초 의약학전문관</strong></a>
					<div class="mt15"></div>
					<a class="pager pager05 ver2" href="javascript:PopAcaInfo('CD0210');"><strong>강북</strong></a>
					<a class="pager pager06 ver2" href="javascript:PopAcaInfo('CD0211');"><strong>노량진</strong></a>
					<a class="pager pager07 ver2" href="javascript:PopAcaInfo('CD0213');"><strong>신촌</strong></a>
					<a class="pager pager08 ver2" href="javascript:PopAcaInfo('CD0276');"><strong>송파</strong></a>
					<a class="pager pager09 ver2" href="javascript:PopAcaInfo('CD0251');"><strong>부천</strong></a>
					<div class="mt15"></div>
					<a class="pager pager10 ver2" href="javascript:PopAcaInfo('CD0253');"><strong>분당</strong></a>
					<a class="pager pager11 ver2" href="javascript:PopAcaInfo('CD0255');"><strong>일산</strong></a>
					<a class="pager pager12 ver2" href="javascript:PopAcaInfo('CD0217');"><strong>평촌</strong></a>
					<a class="pager12 ver2 link" href="http://suwonmega.com" target="_blank"><strong><span>수원<em>(협력)</em></span></strong></a>

					<h4><strong>초중고 종합/단과</strong></h4>
					<a class="pager pager14 ver2" href="javascript:PopAcaInfo('CD0209');"><strong>강북</strong></a>
					<a class="pager pager15 ver2" href="javascript:PopAcaInfo('CD0214');"><strong>성북</strong></a>
					<!-- <a class="pager pager16 ver2" href="javascript:PopAcaInfo('CD0259');"><strong>양주</strong></a> -->

					<h4><strong>컨설팅 입시/면접</strong></h4>
					<a class="pager14 ver4 link" href="http://mmcc.megastudy.net" target="_blank"><strong>대입컨설팅센터</strong></a>
				</div>
			</div>

			<div class="pager_pop_wrap main_pager m_inner of_hid">
				<div class="pager_inner m_inner">
					<span class="close_btn"><img src="<%=Application("img_path_mob")%>/asset/img/pop_ban_close_btn.png" alt="" /></span>
					<!-- 학원정보 보여지는 부분 -->
					<span id="AcaInfoView"></span>

				</div>
			</div>
			<!-- //학원 바로가기 -->

			<!-- 공지사항 -->
		<%
			If Not IsNull(arrIntroMegaByRS) Then
		%>
			<div class="notice_wrap">
				<div class="notice_layout m_inner cl">
					<strong>공지사항</strong>
					<ul class="notice_area">
						<%
							If isarray(arrIntroMegaByRS) Then
								For iib = 0 To ubound(arrIntroMegaByRS, 2)
									IntroMegaBy_CODE		= arrIntroMegaByRS(0, iib)
									IntroMegaBy_SUBJECT	= arrIntroMegaByRS(1, iib)
									IntroMegaBy_RegDate		= arrIntroMegaByRS(3, iib)
									IntroMegaBy_DtDff		= arrIntroMegaByRS(6, iib)
						%>
									<li><a href="/common/notice/notice_view.asp?code=<%=IntroMegaBy_CODE%>""><%=IntroMegaBy_SUBJECT%><%If IntroMegaBy_DtDff <= 7 Then%><%End If%></a></li>
						<%
								Next
							End If
						%>
					</ul>
					<a href="/common/notice/notice.asp"><span class=""></span></a>
				</div>
			</div>
			<!-- //공지사항 -->
		<%
			End if
		%>
			<!-- SNS -->
			<div class="sns_wrap">
				<ul class="sns_area cl">
					<li><a href="https://m.blog.naver.com/mega_campus" target="_blank"><span><img src="<%=Application("img_path_mob")%>/asset/img/m_sns_icon01.png" alt="" />공식 블로그</span></a></li>
					<li><a href="https://youtube.com/channel/UCswYdmA65FtgPJjJNDJW0FA" target="_blank"><span><img src="<%=Application("img_path_mob")%>/asset/img/m_sns_icon03.png" alt="" />공식 채널</span></a></li>
				</ul>
			</div>
			<!-- //SNS -->

		</section>

		<!-- footer -->
		<!-- #include virtual="/include/bottom.asp" -->
		<!-- //footer -->


		<!-- 설명회 레이어 -->
		<!-- #include virtual="/include/inc_main_fair_pop.asp" -->
		<!-- // 설명회 레이어 -->
	</section>

	<script src="/asset/js/waypoints.min.js"></script>
	<script src="/asset/js/jquery.counterup.min.js"></script>
	<script>
		$(function(){
			$('.impor_num').counterUp({
				delay: 10,
				time: 500
			});

			$('.num01').counterUp({
				delay: 10,
				time: 500
			});

			$('.num02').counterUp({
				delay: 10,
				time: 600
			});

			$('.num03').counterUp({
				delay: 10,
				time: 500
			});
		});
	</script>
</body>
</html>