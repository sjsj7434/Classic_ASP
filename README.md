# Classic_ASP
클래식 ASP /  작성자 : 이상준

## 공통
>### 가독성을 위해 코드 줄맞춤 조정

>### If문 조건이 False일 때 팝업 스크립트를 읽어오지 않도록 수정

>#### setCookieAt00
>>**setCookieAt00()** 라는 쿠키 생성 Function을 Date()의 setDate, hours, minutes, seconds를 사용하여 알아보기 쉽게 바꿈
><pre>
>    <code>
>        todayDate = new Date(parseInt(todayDate.getTime() / 86400000) * 86400000 + 54000000);
>    </code>
></pre>
><pre>
>    <code>
>        todayDate.setDate(todayDate.getDate() + expiredays);
>        todayDate.setHours(0);
>        todayDate.setMinutes(0);
>        todayDate.setSeconds(0);
>    </code>
></pre>

>#### 팝업 날짜 조건문
>>**getYmdhmin()** 에서도 Now()를 이용하여 날짜를 가져오기 때문에 알아보기 간편하게 수정

>>getYmdhmin() => 현재 년월일시간분을 리턴하는 함수 (YYmmddhhmin)
><pre>
>    <code>
>        If CDbl(getYmdhmin()) >= CDbl(202012021000) And CDbl(getYmdhmin()) < CDbl(202012031800) Then
>    </code>
></pre>
><pre>
>    <code>
>        If "2020-12-02 10:00:00" <= Now() And Now() < "2020-12-03 18:00:00" Then
>    </code>
></pre>

***

## PC
>#### MSP_MG_INDEX_NOTICE
>>공지사항을 가져오는 SQL문을 프로시저로 작성

>#### autoPlayPopCheering
>>변수를 사용해 팝업 영상 자동 재생 제어

>#### index_police_banner.asp
>>경찰대 합격자 배너 따로 분리하여 include (에러나서 내용은 주석처리 유지)

***

## Mobile
>#### laypop_201228Pop, playPopCheering
>>일반 팝업과 동영상 팝업 Open Function을 분리

>#### close_laypop_201228, close_laypop_cheering
>>팝업 닫기를 직접 클릭 이벤트로 지정하지 않고 따로 Function으로 분리