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
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ChatService {

    private final ChatRoomRepository chatRoomRepository;
    private final MessageRepository messageRepository;

    // 채팅방 생성 또는 기존 채팅방 찾기
    public ChatRoom createOrGetChatRoom(String userId1, String userId2) {
        List<String> participants = Arrays.asList(userId1, userId2);

        // 기존 채팅방 찾기
        Optional<ChatRoom> existingRoom = chatRoomRepository
                .findByParticipantsContainingAll(participants);  // 메서드 이름 변경

        if (existingRoom.isPresent()) {
            return existingRoom.get();
        }

        // 새 채팅방 생성
        ChatRoom chatRoom = new ChatRoom();
        chatRoom.setParticipants(participants);
        chatRoom.setCreatedAt(LocalDateTime.now());
        chatRoom.setLastMessageTime(LocalDateTime.now());
        chatRoom.setUnreadCount(0);

        return chatRoomRepository.save(chatRoom);
    }

    // 사용자의 채팅방 목록 조회
    public List<ChatRoom> getUserChatRooms(String userId) {
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

        // 채팅방 정보 업데이트
        updateChatRoomLastMessage(chatRoomId, content, LocalDateTime.now());

        return savedMessage;
    }

    // 채팅방의 메시지 목록 조회
    public List<Message> getChatRoomMessages(String chatRoomId) {
        return messageRepository.findByChatRoomIdOrderByTimestampAsc(chatRoomId);
    }

    // 메시지 읽음 처리
    public void markMessagesAsRead(String chatRoomId, String userId) {
        List<Message> unreadMessages = messageRepository
                .findByChatRoomIdAndIsReadFalseAndSenderIdNot(chatRoomId, userId);

        unreadMessages.forEach(msg -> msg.setRead(true));
        messageRepository.saveAll(unreadMessages);
    }

    // 읽지 않은 메시지 수 조회
    public long getUnreadCount(String chatRoomId, String userId) {
        return messageRepository
                .countByChatRoomIdAndIsReadFalseAndSenderIdNot(chatRoomId, userId);
    }

    // 채팅방 마지막 메시지 업데이트
    private void updateChatRoomLastMessage(String chatRoomId, String lastMessage, LocalDateTime time) {
        chatRoomRepository.findById(chatRoomId).ifPresent(chatRoom -> {
            chatRoom.setLastMessage(lastMessage);
            chatRoom.setLastMessageTime(time);
            chatRoomRepository.save(chatRoom);
        });
    }
}