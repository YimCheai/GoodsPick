<%@ page contentType="text/html; charset=UTF-8" %>
<head>
    <title>굿즈 등록</title>
    <link rel="stylesheet" href="/css/need_post.css">
</head>
<body>
    <%@ include file="components/navbar.jsp" %>
    <div class="navbar-divider"></div> <!-- Added divider -->

    <div class="content-wrapper"> <!-- New wrapper for left/right halves -->
        <div class="left-half">
            <div class="image-upload-area">
                <p>이미지를 여기에 드래그 앤 드롭하거나</p>
            </div>
            <button type="button" class="image-upload-button">이미지 등록</button>
            <input type="file" id="imageUpload" accept="image/*" multiple style="display: none;">
        </div>
        <div class="right-half">
            <div class="form-group">
                <label for="goodsName">굿즈 이름</label>
                <input type="text" id="goodsName" placeholder="굿즈 이름을 입력하세요">
            </div>
            <div class="form-group">
                <label for="goodsDescription">굿즈 설명</label>
                <textarea id="goodsDescription" placeholder="굿즈 설명을 입력하세요" rows="5"></textarea>
            </div>
            <div class="form-group">
                <label>현장 거래</label>
                <div class="radio-group">
                    <input type="radio" id="tradePossible" name="onSiteTrade" value="possible">
                    <label for="tradePossible">가능</label>
                    <input type="radio" id="tradeImpossible" name="onSiteTrade" value="impossible">
                    <label for="tradeImpossible">불가능</label>
                </div>
            </div>
        </div>
    </div>
</body>