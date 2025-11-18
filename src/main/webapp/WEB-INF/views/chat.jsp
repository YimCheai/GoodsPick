<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat</title>

    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

    <style>
        /* 기존 스타일 유지 */
        @import url('https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css');

        body { margin: 0; background-color: #ffffff; font-family: 'Pretendard', sans-serif; width: 100vw; height: 100vh; position: relative; }
        .chat-container { width: 1920px; height: 1080px; background-color: #ffffff; position: relative; }
        .chat-box { width: 1347px; height: 813px; background-color: #F5F6FB; border-radius: 20px; position: absolute; bottom: 43px; right: 98px; }
        .chat-input { position: absolute; width: 1130px; height: 84px; background-color: #FFFFFF; border-radius: 20px; bottom: 61px; left: 48px; border: none; padding-left: 111px; font-family: 'Pretendard', sans-serif; font-weight: 500; font-size: 20px; color: #B5B5B5; }
        .chat-input:focus { outline: none; color: #000000; }
        .chat-img-icon { position: absolute; bottom: 83px; left: 90px; width: 35px; height: 42px; cursor: pointer; }
        .chat-send-icon { position: absolute; bottom: 83px; right: 90px; width: 35px; height: 42px; cursor: pointer; }
        .chat-file-input { display: none; }
        .chat-messages { position: absolute; top: 181px; left: 47px; right: 47px; height: 520px; overflow-y: auto; display: flex; flex-direction: column; }
        .chat-message-wrapper.my-message { display: flex; align-items: flex-end; justify-content: flex-end; margin-bottom: 10px; gap: 8px; }
        .chat-message.my-message { padding: 12px 16px; background-color: #5271FF; border-radius: 12px; display: inline-block; max-width: 70%; word-wrap: break-word; font-family: 'Pretendard', sans-serif; font-weight: 400; font-size: 15px; color: #FFFFFF; }
        .chat-message-wrapper.other-message { display: flex; align-items: flex-start; margin-bottom: 10px; gap: 8px; }
        .chat-message.other-message { padding: 12px 16px; background-color: #FFFFFF; border-radius: 12px; display: inline-block; max-width: 70%; word-wrap: break-word; font-family: 'Pretendard', sans-serif; font-weight: 400; font-size: 15px; color: #000000; }
        .other-message-content { display: flex; align-items: flex-end; gap: 8px; }
        .chat-time { font-family: 'Pretendard', sans-serif; font-weight: 400; font-size: 12px; color: rgba(0, 0, 0, 0.6); white-space: nowrap; align-self: flex-end; }
        .chat-message img { max-width: 300px; max-height: 300px; border-radius: 8px; display: block; margin-top: 5px; }
        .chatbox-profile { position: absolute; top: 21px; left: 41px; }
        .chat-partner-name { position: absolute; top: 40px; left: 120px; font-family: 'Pretendard', sans-serif; font-weight: 600; font-size: 20px; color: #000000; }
        .profile-divider { position: absolute; top: calc(21px + 25px + 50px); left: 50%; transform: translateX(-50%); width: 1300px; height: 1px; background-color: rgba(0, 0, 0, 0.3); }
        .date-box { position: absolute; top: calc(21px + 25px + 50px + 1px + 30px); left: 600px; width: 114px; height: 33px; background-color: rgba(0, 0, 0, 0.3); border-radius: 100px; display: flex; align-items: center; justify-content: center; font-family: 'Pretendard', sans-serif; font-weight: 400; font-size: 12px; color: #FFFFFF; }
        .chat-title { position: absolute; top: 160px; left: 55px; font-family: 'Pretendard', sans-serif; font-weight: 600; font-size: 30px; color: #000000; }
        .chat-svg { position: absolute; top: calc(164px + 22px + 20px); left: 47px; }
        .chat-list-container { position: absolute; top: calc(164px + 22px + 20px + 130px); left: 47px; width: 400px; height: 600px; overflow-y: auto; }
        .chat-list-item { display: flex; align-items: center; padding: 15px 10px; cursor: pointer; border-bottom: 1px solid rgba(0, 0, 0, 0.1); position: relative; }
        .chat-list-item:hover { background-color: rgba(0, 0, 0, 0.05); }
        .chat-list-item.active { background-color: rgba(82, 113, 255, 0.1); }
        .chat-list-profile { width: 50px; height: 50px; border-radius: 50%; margin-right: 12px; flex-shrink: 0; }
        .chat-list-info { flex: 1; overflow: hidden; }
        .chat-list-name { font-family: 'Pretendard', sans-serif; font-weight: 600; font-size: 16px; color: #000000; margin-bottom: 4px; }
        .chat-list-preview { font-family: 'Pretendard', sans-serif; font-weight: 400; font-size: 14px; color: #666666; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .chat-list-meta { display: flex; flex-direction: column; align-items: flex-end; gap: 5px; }
        .chat-list-time { font-family: 'Pretendard', sans-serif; font-weight: 400; font-size: 12px; color: #999999; }
        .chat-list-unread { background-color: #5271FF; color: #FFFFFF; font-family: 'Pretendard', sans-serif; font-weight: 600; font-size: 12px; padding: 2px 8px; border-radius: 10px; min-width: 20px; text-align: center; }
        .other-profile-img { width: 40px; height: 40px; border-radius: 50%; margin-right: 8px; flex-shrink: 0; }
    </style>
</head>
<body>
<div class="chat-container">
    <div class="chat-box">
        <img src="/img/chatbox_profile.svg" alt="Profile" class="chatbox-profile">

        <div class="chat-partner-name" id="chatPartnerName">채팅 상대를 선택하세요</div>

        <div class="profile-divider"></div>

        <div class="date-box" id="dateBox"></div>

        <div class="chat-messages" id="chatMessages"></div>

        <input type="text" id="chatInput" class="chat-input" placeholder="메세지를 입력하세요">

        <label for="chatFileInput">
            <img src="/img/chat_imgicon.svg" alt="이미지 첨부" class="chat-img-icon">
        </label>
        <input type="file" id="chatFileInput" class="chat-file-input" accept="image/*">

        <img src="/img/chat_sendicon.svg" alt="전송" class="chat-send-icon" onclick="sendMessage()">
    </div>

    <div class="chat-title">채팅 내역</div>

    <img src="/img/chatbox.svg" alt="Chat Box" class="chat-svg">

    <div class="chat-list-container" id="chatList"></div>
</div>

<script>
    // 중요: JSP 파일이므로 서버에서 해석해야 할 변수만 EL 표현식으로 감쌉니다.
    // 'loginUser' 객체 안의 'id'와 'username'을 꺼내옵니다.
    // (User 엔티티의 필드명이 id, username 이라고 가정)
    const currentUserId = '${sessionScope.loginUser.id}';
    const currentUserName = '${sessionScope.loginUser.username}';

    let stompClient = null;
    let currentChatRoomId = null;
    let subscription = null;

    // WebSocket 연결
    function connectWebSocket() {
        const socket = new SockJS('/ws-chat');
        stompClient = Stomp.over(socket);

        stompClient.connect({}, function(frame) {
            console.log('Connected: ' + frame);
        }, function(error) {
            console.error('WebSocket 연결 오류:', error);
            setTimeout(connectWebSocket, 5000);
        });
    }

    // 채팅방 구독
    function subscribeToChatRoom(chatRoomId) {
        if (subscription) {
            subscription.unsubscribe();
        }

        subscription = stompClient.subscribe('/topic/chat/' + chatRoomId, function(message) {
            const messageData = JSON.parse(message.body);

            if (messageData.senderId !== currentUserId) {
                displayReceivedMessage(messageData);
            }
        });
    }

    // 채팅 목록 불러오기
    async function loadChatList() {
        try {
            const response = await fetch('/api/chat/rooms?userId=' + currentUserId);
            const chatRooms = await response.json();

            const chatList = document.getElementById('chatList');
            chatList.innerHTML = '';

            for (const room of chatRooms) {
                const otherUserId = room.participants.find(id => id !== currentUserId);
                const unreadCount = await getUnreadCount(room.id);

                const item = document.createElement('div');

                // JS 변수는 + 연산자로 연결합니다
                item.className = 'chat-list-item ' + (room.id == currentChatRoomId ? 'active' : '');
                item.onclick = function() { selectChatRoom(room.id, otherUserId); };

                // HTML 생성 시에도 JS 변수는 문자열 합치기로 처리
                let htmlContent =
                    '<img src="/img/chatbox_profile.svg" alt="Profile" class="chat-list-profile">' +
                    '<div class="chat-list-info">' +
                    '<div class="chat-list-name">' + otherUserId + '</div>' +
                    '<div class="chat-list-preview">' + (room.lastMessage || '대화를 시작하세요') + '</div>' +
                    '</div>' +
                    '<div class="chat-list-meta">' +
                    '<div class="chat-list-time">' + formatTime(room.lastMessageTime) + '</div>';

                if (unreadCount > 0) {
                    htmlContent += '<div class="chat-list-unread">' + unreadCount + '</div>';
                }

                htmlContent += '</div>';

                item.innerHTML = htmlContent;
                chatList.appendChild(item);
            }
        } catch (error) {
            console.error('채팅 목록 로드 실패:', error);
        }
    }

    // 읽지 않은 메시지 수 조회
    async function getUnreadCount(chatRoomId) {
        try {
            const response = await fetch('/api/chat/unread/' + chatRoomId + '?userId=' + currentUserId);
            return await response.json();
        } catch (error) {
            console.error('읽지 않은 메시지 수 조회 실패:', error);
            return 0;
        }
    }

    // 채팅방 선택
    async function selectChatRoom(chatRoomId, otherUserId) {
        currentChatRoomId = chatRoomId;

        document.getElementById('chatPartnerName').textContent = otherUserId;
        document.getElementById('chatMessages').innerHTML = '';

        subscribeToChatRoom(chatRoomId);
        await loadMessages(chatRoomId);
        await markAsRead(chatRoomId);
        loadChatList();
    }

    // 메시지 불러오기
    async function loadMessages(chatRoomId) {
        try {
            const response = await fetch('/api/chat/messages/' + chatRoomId);
            const messages = await response.json();

            const messagesContainer = document.getElementById('chatMessages');
            messagesContainer.innerHTML = '';

            messages.forEach(msg => {
                const isMyMessage = msg.senderId === currentUserId;
                displayMessage(msg.content, msg.imageUrl, isMyMessage, msg.timestamp);
            });

            messagesContainer.scrollTop = messagesContainer.scrollHeight;
        } catch (error) {
            console.error('메시지 로드 실패:', error);
        }
    }

    // 메시지 읽음 처리
    async function markAsRead(chatRoomId) {
        try {
            await fetch('/api/chat/read/' + chatRoomId + '?userId=' + currentUserId, {
                method: 'POST'
            });
        } catch (error) {
            console.error('읽음 처리 실패:', error);
        }
    }

    // 메시지 전송
    function sendMessage() {
        const input = document.getElementById('chatInput');
        const fileInput = document.getElementById('chatFileInput');
        const text = input.value.trim();

        if (!currentChatRoomId) {
            alert('채팅방을 선택해주세요.');
            return;
        }

        if (text === '' && fileInput.files.length === 0) {
            return;
        }

        const messageData = {
            chatRoomId: currentChatRoomId,
            senderId: currentUserId,
            senderName: currentUserName,
            content: text,
            type: 'TEXT',
            timestamp: new Date().toISOString()
        };

        if (fileInput.files.length > 0) {
            const file = fileInput.files[0];
            const reader = new FileReader();

            reader.onload = function(e) {
                messageData.imageUrl = e.target.result;
                messageData.type = 'IMAGE';
                sendMessageToServer(messageData);
                displayMessage(text, e.target.result, true);
                fileInput.value = '';
            };
            reader.readAsDataURL(file);
        } else {
            sendMessageToServer(messageData);
            displayMessage(text, null, true);
        }

        input.value = '';
    }

    // 서버로 메시지 전송
    function sendMessageToServer(messageData) {
        if (stompClient && stompClient.connected) {
            stompClient.send('/app/chat/' + currentChatRoomId, {}, JSON.stringify(messageData));
        } else {
            console.error('WebSocket이 연결되지 않았습니다.');
        }
    }

    // 받은 메시지 표시
    function displayReceivedMessage(messageData) {
        displayMessage(messageData.content, messageData.imageUrl, false, messageData.timestamp);
    }

    // 메시지 표시
    function displayMessage(text, imageUrl, isMyMessage, timestamp) {
        const messages = document.getElementById('chatMessages');
        const msgWrapper = document.createElement('div');
        // JS 변수 연결
        msgWrapper.className = 'chat-message-wrapper ' + (isMyMessage ? 'my-message' : 'other-message');

        if (isMyMessage) {
            const timeSpan = document.createElement('span');
            timeSpan.className = 'chat-time';
            timeSpan.textContent = formatMessageTime(timestamp);

            const msgDiv = document.createElement('div');
            msgDiv.className = 'chat-message my-message';

            if (text) msgDiv.textContent = text;
            if (imageUrl) {
                const img = document.createElement('img');
                img.src = imageUrl;
                msgDiv.appendChild(img);
            }

            msgWrapper.appendChild(timeSpan);
            msgWrapper.appendChild(msgDiv);
        } else {
            const profileImg = document.createElement('img');
            profileImg.src = '/img/chatbox_profile.svg';
            profileImg.className = 'other-profile-img';

            const contentDiv = document.createElement('div');
            contentDiv.className = 'other-message-content';

            const msgDiv = document.createElement('div');
            msgDiv.className = 'chat-message other-message';

            if (text) msgDiv.textContent = text;
            if (imageUrl) {
                const img = document.createElement('img');
                img.src = imageUrl;
                msgDiv.appendChild(img);
            }

            const timeSpan = document.createElement('span');
            timeSpan.className = 'chat-time';
            timeSpan.textContent = formatMessageTime(timestamp);

            contentDiv.appendChild(msgDiv);
            contentDiv.appendChild(timeSpan);
            msgWrapper.appendChild(profileImg);
            msgWrapper.appendChild(contentDiv);
        }

        messages.appendChild(msgWrapper);
        messages.scrollTop = messages.scrollHeight;
    }

    // 시간 포맷팅
    function formatMessageTime(timestamp) {
        if (!timestamp) {
            const now = new Date();
            return formatTime(now);
        }
        const date = new Date(timestamp);
        return formatTime(date);
    }

    function formatTime(dateTime) {
        if (!dateTime) return '';

        const date = new Date(dateTime);
        let hours = date.getHours();
        const minutes = String(date.getMinutes()).padStart(2, '0');
        const period = hours >= 12 ? '오후' : '오전';
        hours = hours % 12 || 12;

        // JS Template Literal 충돌 방지
        return period + ' ' + hours + ':' + minutes;
    }

    // 현재 날짜 표시
    function updateDate() {
        const dateBox = document.getElementById('dateBox');
        const now = new Date();
        const year = String(now.getFullYear()).slice(2);
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const day = String(now.getDate()).padStart(2, '0');
        const days = ['일', '월', '화', '수', '목', '금', '토'];
        const dayOfWeek = days[now.getDay()];

        // JS Template Literal 충돌 방지
        dateBox.textContent = year + '. ' + month + '.' + day + '(' + dayOfWeek + ')';
    }

    // 엔터키로 전송
    document.getElementById('chatInput').addEventListener('keydown', function(e) {
        if (e.key === 'Enter') {
            sendMessage();
        }
    });

    // 페이지 로드 시 초기화
    window.onload = function() {
        if (!currentUserId) {
            alert('로그인이 필요합니다.');
            window.location.href = '/login';
            return;
        }

        updateDate();
        connectWebSocket();

        // WebSocket 연결 후 채팅 목록 로드
        setTimeout(() => {
            loadChatList();
        }, 1000);
    };

    // 페이지 종료 시 연결 해제
    window.onbeforeunload = function() {
        if (stompClient) {
            stompClient.disconnect();
        }
    };
</script>
</body>
</html>