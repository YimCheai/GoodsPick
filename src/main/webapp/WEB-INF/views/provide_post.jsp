<%@ page contentType="text/html; charset=UTF-8" %>
<head>
    <title>굿즈 제공</title>
    <link rel="stylesheet" href="/css/need_post.css?v=1.1"> <%-- Reusing existing CSS --%>
    <link rel="stylesheet" href="/css/navbar.css">
</head>
<body>
    <%@ include file="components/navbar.jsp" %>
    <div class="navbar-divider"></div> <!-- Added divider -->

    <form action="/provide_post" method="post" enctype="multipart/form-data">
    <div class="content-wrapper"> <!-- New wrapper for left/right halves -->
        <div class="left-half">
            <div class="image-upload-area">
                <p>이미지를 여기에 드래그 앤 드롭하거나</p>
            </div>
            <button type="button" class="image-upload-button">이미지 등록</button>
            <input type="file" id="imageUpload" name="image" accept="image/*" multiple style="display: none;">
        </div>
        <div class="right-half">
            <div class="form-group">
                <label for="goodsName">굿즈 이름</label>
                <input type="text" id="goodsName" name="goodsName" placeholder="굿즈 이름을 입력하세요">
            </div>
            <div class="form-group">
                <label for="goodsDescription">굿즈 설명</label>
                <textarea id="goodsDescription" name="goodsDescription" placeholder="굿즈 설명을 입력하세요" rows="1"></textarea>
            </div>
            <div class="form-group">
                <label for="price">가격</label>
                <input type="number" id="price" name="price" placeholder="가격을 입력하세요" step="0.01" min="0">
            </div>
            <div class="form-group">
                <label>현장 거래</label>
                <div class="radio-group">
                    <input type="radio" id="tradePossible" name="inPersonTransaction" value="true">
                    <label for="tradePossible">가능</label>
                    <input type="radio" id="tradeImpossible" name="inPersonTransaction" value="false">
                    <label for="tradeImpossible">불가능</label>
                </div>
            </div>
             <button type="submit" class="post-button">게시</button>
        </div>
    </div>
</form>

<script>
    const uploadArea = document.querySelector('.image-upload-area');
    const uploadButton = document.querySelector('.image-upload-button');
    const fileInput = document.getElementById('imageUpload');

    // 1. "이미지 등록" button click
    uploadButton.addEventListener('click', () => {
        fileInput.click();
    });

    // 2. Handle file selection via file dialog
    fileInput.addEventListener('change', (e) => {
        const files = e.target.files;
        if (files.length > 0) {
            handleFiles(files);
        }
    });

    // 3. Drag and Drop
    // Prevent default drag behaviors
    ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
        uploadArea.addEventListener(eventName, preventDefaults, false);
        document.body.addEventListener(eventName, preventDefaults, false); // Also on body
    });

    function preventDefaults(e) {
        e.preventDefault();
        e.stopPropagation();
    }

    // Highlight drop area when item is dragged over it
    ['dragenter', 'dragover'].forEach(eventName => {
        uploadArea.addEventListener(eventName, highlight, false);
    });

    ['dragleave', 'drop'].forEach(eventName => {
        uploadArea.addEventListener(eventName, unhighlight, false);
    });

    function highlight(e) {
        uploadArea.classList.add('highlight');
    }

    function unhighlight(e) {
        uploadArea.classList.remove('highlight');
    }

    // Handle dropped files
    uploadArea.addEventListener('drop', (e) => {
        const dt = e.dataTransfer;
        const files = dt.files;
        handleFiles(files);
    });

    // 4. File handling logic (displaying image previews)
    function handleFiles(files) {
        uploadArea.innerHTML = ""; // Clear existing content

        if (files.length === 0) {
            uploadArea.innerHTML = "<p>이미지를 여기에 드래그 앤 드롭하거나</p>";
            return;
        }

        const file = files[0]; // Only preview the first file for now
        if (file.type.startsWith('image/')) {
            const reader = new FileReader();
            reader.onload = (e) => {
                const img = document.createElement('img');
                img.src = e.target.result;
                img.style.maxWidth = '100%';
                img.style.maxHeight = '100%';
                img.style.objectFit = 'contain'; // Ensure the image fits within the area
                img.alt = file.name;
                uploadArea.appendChild(img);
            };
            reader.readAsDataURL(file);
        } else {
            uploadArea.innerHTML = "<p>선택된 파일은 이미지가 아닙니다.</p>";
        }
    }

    // Auto-resize textarea
    const goodsDescriptionTextarea = document.getElementById('goodsDescription');

    function autoResizeTextarea() {
        goodsDescriptionTextarea.style.height = 'auto'; // Reset height to recalculate scrollHeight
        goodsDescriptionTextarea.style.height = goodsDescriptionTextarea.scrollHeight + 'px';
    }

    // Call resize on input and cut events
    goodsDescriptionTextarea.addEventListener('input', autoResizeTextarea);
    goodsDescriptionTextarea.addEventListener('cut', autoResizeTextarea); // For cutting text

    // Call once on page load to set initial height
    autoResizeTextarea(); 
</script>
</body>
