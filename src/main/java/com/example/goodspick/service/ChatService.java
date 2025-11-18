package com.example.goodspick.service;

import com.example.goodspick.entity.ChatRoom;
import com.example.goodspick.entity.Message;
import com.example.goodspick.repository.ChatRoomRepository;
import com.example.goodspick.repository.MessageRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ChatService {

    private final ChatRoomRepository chatRoomRepository;
    private final MessageRepository messageRepository;

    /**
     * 채팅방 생성 또는 기존 채팅방 찾기
     * (Controller에서 createChatRoom이라고 호출하므로 이름을 맞췄습니다)
     */
    public ChatRoom createChatRoom(String userId1, String userId2) {
        List<String> participants = Arrays.asList(userId1, userId2);

        // 1. 기존 채팅방 찾기
        // (아까 Repository에 @Query로 추가한 메서드 사용)
        return chatRoomRepository.findChatRoomByParticipants(participants)
                .orElseGet(() -> {
                    // 2. 없으면 새 채팅방 생성
                    ChatRoom chatRoom = new ChatRoom();
                    chatRoom.setParticipants(participants);
                    chatRoom.setCreatedAt(LocalDateTime.now());
                    chatRoom.setLastMessage("대화를 시작해보세요!");
                    chatRoom.setLastMessageTime(LocalDateTime.now());
                    chatRoom.setUnreadCount(0);
                    return chatRoomRepository.save(chatRoom);
                });
    }

    // 사용자의 채팅방 목록 조회
    public List<ChatRoom> getUserChatRooms(String userId) {
        // Containing은 배열 안에 해당 값이 포함되어 있는지 확인합니다 (MongoDB 기본 지원)
        return chatRoomRepository.findByParticipantsContaining(userId);
    }

    // 메시지 저장
    public Message saveMessage(String chatRoomId, String senderId, String senderName,
                               String content, String imageUrl, Message.MessageType type) {
        Message message = new Message();
        message.setChatRoomId(chatRoomId);
        message.setSenderId(senderId);
        message.setSenderName(senderName);
        message.setContent(content);
        message.setImageUrl(imageUrl);
        message.setType(type);
        message.setTimestamp(LocalDateTime.now());
        message.setRead(false);

        Message savedMessage = messageRepository.save(message);

        // 채팅방 정보 업데이트 (마지막 메시지, 시간)
        updateChatRoomLastMessage(chatRoomId, content, LocalDateTime.now());

        return savedMessage;
    }

    // 채팅방의 메시지 목록 조회
    public List<Message> getChatRoomMessages(String chatRoomId) {
        return messageRepository.findByChatRoomIdOrderByTimestampAsc(chatRoomId);
    }

    // 메시지 읽음 처리
    public void markMessagesAsRead(String chatRoomId, String userId) {
        // 내가 보낸 메시지가 아니고(Not), 읽지 않은(False) 메시지만 찾음
        List<Message> unreadMessages = messageRepository
                .findByChatRoomIdAndIsReadFalseAndSenderIdNot(chatRoomId, userId);

        if (!unreadMessages.isEmpty()) {
            unreadMessages.forEach(msg -> msg.setRead(true));
            messageRepository.saveAll(unreadMessages);
        }
    }

    // 읽지 않은 메시지 수 조회
    public long getUnreadCount(String chatRoomId, String userId) {
        return messageRepository
                .countByChatRoomIdAndIsReadFalseAndSenderIdNot(chatRoomId, userId);
    }

    // 내부 메서드: 채팅방 마지막 메시지 업데이트
    private void updateChatRoomLastMessage(String chatRoomId, String lastMessage, LocalDateTime time) {
        chatRoomRepository.findById(chatRoomId).ifPresent(chatRoom -> {
            chatRoom.setLastMessage(lastMessage);
            chatRoom.setLastMessageTime(time);
            chatRoomRepository.save(chatRoom);
        });
    }
}