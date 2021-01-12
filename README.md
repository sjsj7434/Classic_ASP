# Classic_ASP
클래식 ASP /  작성자 : 이상준

## 공통
>setCookieAt00
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


<html>
    <head></head>
    <body>
        <div>
            <h1>공통</h1>
            <div>
                <h2>setCookieAt00</h2>
                <div>
                    <p>
                        setCookieAt00라는 쿠키 생성 Function을 Date()의 setDate,hours,minutes,seconds를 사용하여 알아보기 쉽게 바꿈
                    </p>
                </div>
            </div>
        </div>
        <div>
            <h1>PC</h1>
            <div>
                <p>
                    공지사항을 가져오는 SQL문을 프로시저로 작성(MSP_MG_INDEX_NOTICE)
                </p>
                <p>
                    autoPlayPopCheering이라는 변수를 사용해 자동 영상 재생 제어
                </p>
            </div>
        </div>
        <div>
            <h1>Mobile</h1>
            <div>
                <p>
                    일반 팝업과 동영상 팝업 Open Function을 분리 (laypop_201228Pop, playPopCheering)
                </p>
                <p>
                    팝업 닫기를 직접 클릭 이벤트로 지정하지 않고 따로 Function으로 분리 (close_laypop_201228, close_laypop_cheering)
                </p>
                <p>
                    팝업 닫기를 직접 클릭 이벤트로 지정하지 않고 따로 Function으로 분리 (close_laypop_201228, close_laypop_cheering)
                </p>
            </div>
        </div>
    </body>
</html>
