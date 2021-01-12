# Classic_ASP
클래식 ASP /  작성자 : 이상준

## 공통
>setCookieAt00
>>**setCookieAt00** 라는 쿠키 생성 Function을 Date()의 setDate, hours, minutes, seconds를 사용하여 알아보기 쉽게 바꿈
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

***

## PC
>MSP_MG_INDEX_NOTICE
>>공지사항을 가져오는 SQL문을 프로시저로 작성

>autoPlayPopCheering
>>변수를 사용해 팝업 영상 자동 재생 제어

***

## Mobile
>laypop_201228Pop, playPopCheering
>>일반 팝업과 동영상 팝업 Open Function을 분리
>close_laypop_201228, close_laypop_cheering
>>팝업 닫기를 직접 클릭 이벤트로 지정하지 않고 따로 Function으로 분리 