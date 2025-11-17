<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<head>
    <title>굿즈 수정</title>
    <link rel="stylesheet" href="/css/need_post.css?v=1.1">
    <link rel="stylesheet" href="/css/navbar.css">
</head>
<body>
    <%@ include file="components/navbar.jsp" %>
    <div class="navbar-divider"></div>

    <form action="${pageContext.request.contextPath}/need/edit/${needItem.id}" method="post" enctype="multipart/form-data">
        <div class="content-wrapper">
            <div class="left-half">
                <div class="image-upload-area">
                    <c:choose>
                        <c:when test="${not empty needItem.imagePath}">
                            <img src="${needItem.imagePath}" alt="Current Image" style="max-width: 100%; max-height: 100%; object-fit: contain;">
                        </c:when>
                        <c:otherwise>
                            <p>이미지를 여기에 드래그 앤 드롭하거나</p>
                        </c:otherwise>
                    </c:choose>
                </div>
                <p style="text-align: center; color: #888; margin-top: 10px;">새 이미지를 업로드하여 변경할 수 있습니다.</p>
                <button type="button" class="image-upload-button">이미지 변경</button>
                <input type="file" id="imageUpload" name="image" accept="image/*" style="display: none;">
            </div>
            <div class="right-half">
                <div class="form-group">
                    <label for="goodsName">굿즈 이름</label>
                    <input type="text" id="goodsName" name="goodsName" value="${needItem.goodsName}" placeholder="굿즈 이름을 입력하세요">
                </div>
                <div class="form-group">
                    <label for="goodsDescription">굿즈 설명</label>
                    <textarea id="goodsDescription" name="goodsDescription" placeholder="굿즈 설명을 입력하세요" rows="1">${needItem.goodsDescription}</textarea>
                </div>
                <div class="form-group">
                    <label>현장 거래</label>
                    <div class="radio-group">
                        <input type="radio" id="tradePossible" name="inPersonTransaction" value="true" ${needItem.inPersonTransaction ? 'checked' : ''}>
                        <label for="tradePossible">가능</label>
                        <input type="radio" id="tradeImpossible" name="inPersonTransaction" value="false" ${!needItem.inPersonTransaction ? 'checked' : ''}>
                        <label for="tradeImpossible">불가능</label>
                    </div>
                </div>
                <button type="submit" class="post-button">수정하기</button>
            </div>
        </div>
    </form>

    <script>
        // This script is similar to need_post.jsp for image preview and textarea auto-resize
        const uploadArea = document.querySelector('.image-upload-area');
        const uploadButton = document.querySelector('.image-upload-button');
        const fileInput = document.getElementById('imageUpload');

        uploadButton.addEventListener('click', () => {
            fileInput.click();
        });

        fileInput.addEventListener('change', (e) => {
            const files = e.target.files;
            if (files.length > 0) {
                handleFiles(files);
            }
        });

        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
            uploadArea.addEventListener(eventName, preventDefaults, false);
        });

        function preventDefaults(e) {
            e.preventDefault();
            e.stopPropagation();
        }

        uploadArea.addEventListener('drop', (e) => {
            const dt = e.dataTransfer;
            const files = dt.files;
            handleFiles(files);
        });

        function handleFiles(files) {
            uploadArea.innerHTML = ""; // Clear existing content
            const file = files[0];
            if (file.type.startsWith('image/')) {
                const reader = new FileReader();
                reader.onload = (e) => {
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.style.maxWidth = '100%';
                    img.style.maxHeight = '100%';
                    img.style.objectFit = 'contain';
                    uploadArea.appendChild(img);
                };
                reader.readAsDataURL(file);
            }
        }

        const goodsDescriptionTextarea = document.getElementById('goodsDescription');
        function autoResizeTextarea() {
            goodsDescriptionTextarea.style.height = 'auto';
            goodsDescriptionTextarea.style.height = goodsDescriptionTextarea.scrollHeight + 'px';
        }
        goodsDescriptionTextarea.addEventListener('input', autoResizeTextarea);
        autoResizeTextarea(); // Initial call
    </script>
</body>
